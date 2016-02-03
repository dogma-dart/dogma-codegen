// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains functions for using the dart analyzer.
library dogma_codegen.src.analyzer.annotation;

//---------------------------------------------------------------------
// Standard Libraries
//---------------------------------------------------------------------

import 'dart:mirrors';

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

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
      var representationName = representation.name;
      var mirror = _getSerializeMirror();

      // Annotations are constant so get the result of the evaluation
      //
      // This ends up creating a generic object containing the resulting
      // fields of the instance. Since the constructors of Serialize always use
      // the this.value notation the evaluated results can be directly used.
      var evaluatedFields = element.evaluationResult.value.fields;

      // Get the invocation
      var positionalArguments = [];
      var namedArguments = <Symbol, dynamic>{};

      for (var parameter in representation.parameters) {
        var parameterName = parameter.name;
        var parameterField = evaluatedFields[parameterName];

        if (representationName == 'function') {
          if (parameterName == 'encode') {
            parameterField = evaluatedFields['encodeUsing'];
          } else if (parameterName == 'decode') {
            parameterField = evaluatedFields['decodeUsing'];
          }
        }

        var parameterValue;

        // Check to see if the value is mapping which currently requires
        // special treatment. This is using information from the private
        // fields of the state data so it can break if those details change.
        if (parameterName == 'mapping') {
          var entries = parameterField.toMapValue();

          // Get the values of the enumeration
          //
          // Just use the type element from the first value of the map to get
          // the list of enumerations.
          var enumerations = enumValues(entries.values.first.type.element);

          // Generate the map of data
          parameterValue = {};

          entries.forEach((key, value) {
            var enumIndex = value.getField('index').toIntValue();

            parameterValue[_toDartValue(key)] = enumerations[enumIndex];
          });
        } else {
          parameterValue = _toDartValue(parameterField);
        }

        if (parameter.parameterKind.name == 'NAMED') {
          namedArguments[new Symbol(parameterName)] = parameterValue;
        } else {
          positionalArguments.add(parameterValue);
        }
      }

      // Create the instance
      value = mirror.newInstance(
          new Symbol(representationName),
          positionalArguments,
          namedArguments
      ).reflectee;
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
bool verifySerializeField(Serialize annotation) => annotation.name.isNotEmpty;

/// Checks whether the [element] is referring to the [Serialize] class.
bool _isSerializeAnnotation(ClassElement element) =>
    element.name == 'Serialize';

/// Retrieves the class mirror for [Serialize].
ClassMirror _getSerializeMirror() {
  if (_serializeMirror == null) {
    var library = currentMirrorSystem().findLibrary(_serializeLibrarySymbol);
    _serializeMirror = library.declarations[_serializeSymbol];
  }

  return _serializeMirror;
}

/// Attempts to convert the [value] into a Dart object.
dynamic _toDartValue(DartObjectImpl value) {
  var typeName = value.type.displayName;

  switch (typeName) {
    case 'String':
      return value.toStringValue();
    case 'Map':
      return value.toMapValue();
    case 'int':
      return value.toIntValue();
    case 'double':
      return value.toDoubleValue();
    case 'bool':
      return value.toBoolValue();
    case 'Null':
      return null;
    default:
      assert(false);
      return null;
  }
}
