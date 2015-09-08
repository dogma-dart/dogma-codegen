// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [ModelConverterGenerator] class.
library dogma_codegen.src.codegen.model_converter_generator;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/identifier.dart';
import 'package:dogma_codegen/metadata.dart';

import 'argument_buffer.dart';
import 'class_generator.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// The named constructor to use when specifying all arguments.
const String _namedConstructor = 'using';

const String _decoderInput = 'input';

String _generateFieldVariable(String modelName, FieldMetadata field) {
  return '_$modelName${camelToPascalCase(field.name)}';
}

void generateModelFieldVariables(ModelMetadata metadata,
                                 StringBuffer buffer,
                                [bool decoder = true,
                                 bool encoder = true])
{
  var fields;

  if (decoder && encoder) {
    fields = metadata.convertibleFields;
  } else if (decoder) {
    fields = metadata.decodableFields;
  } else {
    fields = metadata.encodableFields;
  }

  var name = pascalToCamelCase(metadata.name);

  for (var field in fields) {
    buffer.write('const String ');
    buffer.write(_generateFieldVariable(name, field));
    buffer.write(' = \'');
    buffer.write(field.serializationName);
    buffer.writeln('\';');
  }
}

/// Writes out the class definition for a model decoder using the model's [metadata].
void generateModelDecoder(ConverterMetadata metadata,
                          ModelMetadata model,
                          StringBuffer buffer,
                         {Map<String, FunctionMetadata> decodeThrough})
{
  decodeThrough ??= {};

  // Get the decodable fields
  var builtinDecodableFields = new List<FieldMetadata>();
  var functionDecodableFields = new List<FieldMetadata>();
  var modelDecodableFields = new List<FieldMetadata>();

  for (var field in model.fields) {
    if (field.decode) {
      var type = field.type;

      if (type.isBuiltin) {
        builtinDecodableFields.add(field);
      } else if (decodeThrough.containsKey(type.name)) {
        functionDecodableFields.add(field);
      } else {
        modelDecodableFields.add(field);
      }
    }
  }

  if ((builtinDecodableFields.isEmpty) && (modelDecodableFields.isEmpty)) {
    return;
  }

  // Write the class declaration
  generateClassDeclaration(metadata, buffer);
  buffer.writeln('{');

  if (modelDecodableFields.isNotEmpty) {
    // Get the dependencies
    var decoderDependencies = new List<TypeMetadata>();

    for (var dependency in modelDecoderDependencies(model)) {
      // Check if a function will be used
      if (!decodeThrough.containsKey(dependency.name)) {
        decoderDependencies.add(dependency);
      }
    }

    // Write the member variable declarations
    _writeMemberVariables(decoderDependencies, 'Decoder', buffer);

    // Write the constructors
    _writeConstructors(metadata.name, decoderDependencies, 'Decoder', buffer);
  }

  var modelName = model.name;

  // Write the create function
  buffer.writeln('@override');
  buffer.writeln('$modelName create() => new $modelName();\n');

  // Write the convert function
  buffer.writeln('@override');
  buffer.writeln('$modelName convert(Map $_decoderInput, [$modelName model = null]) {');
  buffer.writeln('model ??= create();\n');

  // Write the builtin fields
  for (var field in builtinDecodableFields) {
    buffer.writeln('model.${field.name} = $_decoderInput[\'${field.serializationName}\'];');
  }

  buffer.writeln();

  for (var field in functionDecodableFields) {
    var decoder = decodeThrough[field.type.name];

    buffer.writeln('model.${field.name} = ${decoder.name}($_decoderInput[\'${field.serializationName}\']);');
  }

  // Write the model fields
  for (var field in modelDecodableFields) {
    var fieldName = field.name;
    var fieldIdentifier = 'model.$fieldName';
    var type = field.type;
    var typeName = type.name;
    var convertSource;

    // \TODO Handle lists
    if (decodeThrough.containsKey(typeName)) {
      var function = decodeThrough[typeName];

      convertSource = '${function.name}($_decoderInput[\'${field.serializationName}\'])';
    } else {
      convertSource = '${_privateConverterName(typeName, 'Decoder')}.convert($_decoderInput[\'${field.serializationName}\'])';
    }

    buffer.writeln('$fieldIdentifier = $convertSource;');
  }

  buffer.writeln('return model;');
  buffer.writeln('}');

  buffer.writeln('}');
}

/// Writes out the class definition for a model encoder using the model's [metadata].
void generateModelEncoder(ModelMetadata metadata, StringBuffer buffer) {
  // Get the names
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
}

void _writeMemberVariables(List<TypeMetadata> dependencies,
                           String append,
                           StringBuffer buffer)
{
  for (var dependency in dependencies) {
    var typeName = dependency.name;

    buffer.writeln('final Model$append<$typeName> _${_converterName(typeName, append)};');
  }

  buffer.writeln();
}

void _writeConstructors(String name,
                        List<TypeMetadata> dependencies,
                        String append,
                        StringBuffer buffer)
{
  var argumentBuffer;

  // Write the factory constructor
  buffer.writeln('factory $name() {');
  argumentBuffer = new ArgumentBuffer();

  for (var dependency in dependencies) {
    var typeName = dependency.name;
    var varName = '${pascalToCamelCase(typeName)}$append';

    argumentBuffer.write(varName);
    buffer.writeln('var $varName = new $typeName$append();');
  }

  buffer.writeln('return new $name.$_namedConstructor(${argumentBuffer.toString()});');
  buffer.writeln('}\n');

  // Write the explicit constructor
  argumentBuffer = new ArgumentBuffer();

  for (var dependency in dependencies) {
    argumentBuffer.write('this.${_privateConverterName(dependency.name, append)}');
  }

  buffer.write('$name.$_namedConstructor(');
  buffer.write(argumentBuffer.toString());
  buffer.write(');\n');
}

String _converterName(String type, String append) {
  return '${pascalToCamelCase(type)}$append';
}

String _privateConverterName(String type, String append) {
  return '_' + _converterName(type, append);
}
