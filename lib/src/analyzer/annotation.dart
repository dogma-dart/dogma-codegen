// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains functions for using the dart analyzer.
library dogma_codegen.src.analyzer.annotation;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'dart:mirrors';

import 'package:analyzer/src/generated/constant.dart';
import 'package:analyzer/src/generated/element.dart';
import 'package:dogma_convert/serialize.dart';

import 'utils.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// The mirror for the [Serialize] class.
ClassMirror _serializeMirror;
/// The name for the [Serialize] class.
///
/// The analyzer contents don't use symbols but just string names instead.
const String _serializeClassName = 'Serialize';
/// The symbol for the [Serialize] annotation.
const Symbol _serializeSymbol = #Serialize;
/// The symbol for the library containing the [Serialize] annotation;
const Symbol _serializeLibrarySymbol = #dogma_convert.serialize;

/// Retrieves the corresponding [Serialize] annotation if the [element] references one.
Serialize annotation(ElementAnnotationImpl element) {
  var representation = element.element;
  var value;

  if (representation is ConstructorElement) {
    if (_isSerializeAnnotation(representation.enclosingElement)) {
      var mirror = _getSerializeMirror();

      // Annotations are constant so get the result of the evaluation
      //
      // This ends up creating a generic object containing the resulting
      // fields of the instance. Since the constructors of Serialize always use
      // the this.value notation the evaluated results can be directly used.
      //
      // NOTE! The constant evaluation results are from a private API so the
      // behavior may change. See https://github.com/dart-lang/sdk/issues/23800
      // for status of the public API.
      var evaluatedFields = element.evaluationResult.value.fields;

      // Get the invocation
      var positionalArguments = [];
      var namedArguments = {};

      for (var parameter in representation.parameters) {
        if (parameter is FieldFormalParameterElementImpl) {
          var parameterName = parameter.name;
          var parameterField = evaluatedFields[parameterName];
          var parameterValue = parameterField.value;

          // Check to see if the value is mapping which currently requires
          // special treatment. This is using information from the private
          // fields of the state data so it can break if those details change.
          if (parameterName == 'mapping') {
            // Use mirrors to get at the actual state
            var fieldInstance = reflect(parameterField);

            // Get the _state field
            var stateInstance = _getPrivateField(fieldInstance, #_state);

            // Get the _entries field
            var entries = _getPrivateField(stateInstance, #_entries).reflectee as Map<DartObject, DartObject>;

            // Get the values of the enumeration
            //
            // Just use the type element from the first value of the map to get
            // the list of enumerations.
            var enumerations = enumValues(entries.values.first.type.element);

            parameterValue = {};

            // Generate the map of data
            entries.forEach((key, value) {
              // Use mirrors to get the index of the enumeration
              var valueState = _getPrivateField(reflect(value), #_state);
              var fieldMap = _getPrivateField(valueState, #_fieldMap).reflectee as Map<String, DartObject>;
              var index = fieldMap['index'].value;

              parameterValue[key.value] = enumerations[index];
            });
          }

          if (parameter.parameterKind.name == 'NAMED') {
            namedArguments[new Symbol(parameterName)] = parameterValue;
          } else {
            positionalArguments.add(parameterValue);
          }
        }
      }

      // Create the instance
      value = mirror.newInstance(new Symbol('${representation.name}'), positionalArguments, namedArguments).reflectee;
    }
  } else if (representation is PropertyAccessorElement) {
    if (_isSerializeAnnotation(representation.enclosingElement)) {
      var mirror = _getSerializeMirror();
      var symbol = new Symbol(representation.name);

      // TODO Error checking on field

      value = mirror.getField(symbol).reflectee;
    }
  }

  return value;
}

/// Searches for a [Serialize] annotation on the [element].
///
/// Returns an instantiated version of [Serialize] if the value is found. This
/// instantiation is as close as possible to the original version given what
/// the analyzer can instantiate within the constant data.
Serialize findAnnotation(Element element) {
  for (var metadata in element.metadata) {
    var result = annotation(metadata);

    if (result != null) {
      return result;
    }
  }

  return null;
}

/// Verify that a field was created by [Serialize.field].
bool verifySerializeField(Serialize annotation) {
  return annotation.name.isNotEmpty;
}

/// Checks whether the [element] is referring to the [Serialize] class.
bool _isSerializeAnnotation(ClassElement element) {
  return element.name == 'Serialize';
}

/// Retrieves the class mirror for [Serialize].
ClassMirror _getSerializeMirror() {
  if (_serializeMirror == null) {
    var library = currentMirrorSystem().findLibrary(_serializeLibrarySymbol);
    _serializeMirror = library.declarations[_serializeSymbol];
  }

  return _serializeMirror;
}

/// Retrieves a private field with the given [symbol] from an instance [mirror].
///
/// A private field can be accessed through the mirrors interface but the actual
/// symbol will contain additional data that prevents an equality from being
/// performed. However the toString() method can be used to compare the symbols
/// successfully.
InstanceMirror _getPrivateField(InstanceMirror mirror, Symbol symbol) {
  var symbolString = symbol.toString();
  var classMirror = mirror.type;

  var fieldSymbol = classMirror.declarations.keys.firstWhere(
      (declarationSymbol) => declarationSymbol.toString() == symbolString);

  return mirror.getField(fieldSymbol);
}
