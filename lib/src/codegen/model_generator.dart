// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.src.codegen.model_generator;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import '../../metadata.dart';

import 'annotation_generator.dart';
import 'class_generator.dart';
import 'field_generator.dart';
import 'type_generator.dart';
import 'serialize_annotation_generator.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// The name of the model within the unmodifiable view.
const String _modelFieldName = '_model';
/// The name of the internal constructor used when a model contains List or Map data.
///
/// When List or Map data is encountered a factory constructor will be used as
/// the default constructor. This is because the views of the data need to be
/// created before they can be set as a final field.
const String _internalConstructorName = '_internal';
/// The name of the variable used in the factory constructor.
const String _factoryVariableName = 'model';

/// Writes out the class definition of a model using its [metadata] to the [buffer].
void generateModel(ModelMetadata metadata, StringBuffer buffer) {
  generateClassDefinition(metadata, buffer, _generateModelDefinition);
}

void _generateModelDefinition(ClassMetadata metadata, StringBuffer buffer) {
  var model = metadata as ModelMetadata;

  // See if an annotation generator is required
  var annotationGenerators = <AnnotationGenerator>[];

  if (model.explicitSerialization) {
    annotationGenerators.add(generateFieldAnnotation);
  }

  // Generate the fields
  generateFields(
      model.fields,
      buffer,
      annotationGenerators: annotationGenerators
  );
}

/// Writes out the class definition for an unmodifiable view over the model using its [metadata] to the [buffer].
///
/// The generated class definition implements the model but prevents
/// modification. Because it implements the model it can be used interchangeably
/// but will throw an [UnsupportedError] if any of the fields are modified.
/// For cases where the field is a List or Map it creates instances of
/// [UnmodifiableListView] and [UnmodifiableMapView] respectively, wrapping the
/// data.
void generateUnmodifiableModelView(ModelMetadata metadata, StringBuffer buffer) {
  // Get the names
  var name = metadata.name;
  var unmodifiableName = 'Unmodifiable${name}View';

  // Write out the class comment
  buffer.writeln('/// An unmodifiable view over an instance of [$name].');

  // Write the class declaration
  buffer.writeln('class $unmodifiableName implements $name {');

  // Write the member variables
  buffer.writeln('final $name $_modelFieldName;');

  var fields = [];
  var unmodifiableFields = [];
  var unmodifiableFieldTypes = [];

  // Group the fields into those that can be used directly and those that
  // require an unmodifiable view
  for (var field in metadata.fields) {
    var fieldType = field.type;

    if ((fieldType.isList) || (fieldType.isMap)) {
      var unmodifiableType = _unmodifiableType(fieldType);

      unmodifiableFields.add(field);
      unmodifiableFieldTypes.add(unmodifiableType);

      // Write out a final variable using the unmodifiable view
      buffer.writeln('final ${generateType(unmodifiableType)} _${field.name};');
    } else {
      fields.add(field);
    }
  }

  var unmodifiableFieldCount = unmodifiableFields.length;

  buffer.writeln();

  // Write the constructor
  if (unmodifiableFieldCount > 0) {
    // Write out a factor constructor to handle creating unmodifiable views
    buffer.writeln('factory $unmodifiableName($name $_factoryVariableName) {');

    // Write out variable declarations
    for (var i = 0; i < unmodifiableFieldCount; ++i) {
      buffer.writeln(_unmodifiableInstance(unmodifiableFields[i], unmodifiableFieldTypes[i]));
    }

    // Write out the call to internal constructor
    buffer.write('return new $unmodifiableName.$_internalConstructorName(');
    buffer.write('$_factoryVariableName');

    for (var i = 0; i < unmodifiableFieldCount; ++i) {
      buffer.write(', ${unmodifiableFields[i].name}');
    }

    buffer.writeln(');');
    buffer.writeln('}\n');

    // Write out the internal constructor
    buffer.write('$unmodifiableName.$_internalConstructorName(');
    buffer.write('this.$_modelFieldName');

    for (var i = 0; i < unmodifiableFieldCount; ++i) {
      buffer.write(', this._${unmodifiableFields[i].name}');
    }

    buffer.writeln(');');
  } else {
    // Create a standard constructor
    buffer.writeln('$unmodifiableName(this.$_modelFieldName);');
  }

  // Write the properties
  for (var field in fields) {
    var type = generateType(field.type);
    var fieldName = field.name;

    buffer.writeln();
    buffer.writeln('@override');
    buffer.writeln('$type get $fieldName => $_modelFieldName.$fieldName;');
    buffer.writeln('set $fieldName($type value) { throw new UnsupportedError(\'Cannot modify an unmodifiable $name\'); }');
  }

  for (var field in unmodifiableFields) {
    var type = generateType(field.type);
    var fieldName = field.name;

    buffer.writeln();
    buffer.writeln('@override');
    buffer.writeln('$type get $fieldName => _$fieldName;');
    buffer.writeln('set $fieldName($type value) { throw new UnsupportedError(\'Cannot modify an unmodifiable $name\'); }');
  }

  // Close the class declaration
  buffer.writeln('}');
}

/// Creates the code to create an unmodifiable view over the [field] with the given [type].
///
/// \TODO handle nested Lists/Maps.
String _unmodifiableInstance(FieldMetadata field, TypeMetadata type) {
  var fieldName = field.name;

  return 'var $fieldName = new ${generateType(type)}($_factoryVariableName.$fieldName);';
}

/// Creates the unmodifiable equivalent of the given [metadata].
///
/// Looks for whether the [metadata] is a List or a Map and creates metadata
/// using the unmodifiable equivalent in the collection library.
TypeMetadata _unmodifiableType(TypeMetadata metadata) {
  var isList = metadata.isList;

  if (isList || metadata.isMap) {
    var unmodifiableTypeName = (isList)
        ? 'UnmodifiableListView'
        : 'UnmodifiableMapView';

    var arguments = <TypeMetadata>[];

    for (var argument in metadata.arguments) {
      arguments.add(_unmodifiableType(argument));
    }

    return new TypeMetadata(unmodifiableTypeName, arguments: arguments);
  } else {
    return metadata;
  }
}
