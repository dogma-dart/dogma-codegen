// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [ModelConverterGenerator] class.
library dogma_codegen.src.codegen.model_converter_generator;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Writes out the class definition for a model decoder using the model's [metadata].
String generateModelDecoder(ModelMetadata metadata) {
  // Get the decodable fields
  var builtinDecodableFields = new List<FieldMetadata>();
  var modelDecodableFields = new List<FieldMetadata>();

  for (var field in metadata.fields) {
    if (field.decode) {
      if (field.type.isBuiltin) {
        builtinDecodableFields.add(field);
      } else {
        modelDecodableFields.add(field);
      }
    }
  }

  if (builtinDecodableFields.isEmpty) {
    return '';
  }

  // Get the names
  var buffer = new StringBuffer();
  var modelName = metadata.name;
  var name = modelName + 'Decoder';

  // Write the class declaration
  buffer.writeln('class $name extends Converter<Map, $modelName> implements ModelDecoder<$modelName> {');

  // Write the create function
  buffer.writeln('@override');
  buffer.writeln('$modelName create() => new $modelName();\n');

  // Write the convert function
  buffer.writeln('@override');
  buffer.writeln('$modelName convert(Map input, [$modelName model = null]) {');
  buffer.writeln('model ??= create();\n');

  // Write the builtin fields
  for (var field in builtinDecodableFields) {
    buffer.writeln('model.${field.name} = input[\'${field.serializationName}\'];');
  }

  buffer.writeln();

  // Write the model fields
  for (var field in modelDecodableFields) {
    var fieldIdentifier = 'model.${field.name}';
    buffer.writeln('$fieldIdentifier = _modelDecoder.convert(input, $fieldIdentifier);');
  }

  buffer.writeln('return model;');
  buffer.writeln('}');

  buffer.writeln('}');

  return buffer.toString();
}

String generateModelEncoder(ModelMetadata metadata) {
  // Get the names
  var buffer = new StringBuffer();
  var modelName = metadata.name;
  var name = modelName + 'Encoder';

  // Write the class declaration
  buffer.writeln('class $name extends Converter<$modelName, Map> implements ModelEncoder<$modelName> {');

  // Write the convert function
  buffer.writeln('@override');
  buffer.writeln('Map convert($modelName input) {');
  buffer.writeln('var output = {};');
  buffer.writeln('return output;');
  buffer.writeln('}');

  buffer.writeln('}');

  return buffer.toString();
}
