// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.src.codegen.enum_converter_generator;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';

import 'function_generator.dart';
import 'field_generator.dart';
import 'serialize_annotation_generator.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Name for the map containing decoded values
const String _decoded = '_decoded';
/// Name for the list containing encoded values.
const String _encoded = '_encoded';
/// Name for the defaults to parameter.
const String _defaultsTo = 'defaultsTo';

void generateEnumDecoder(ConverterFunctionMetadata metadata,
                         EnumMetadata enumeration,
                         StringBuffer buffer)
{
  // Create the value declaration
  var field = new FieldMetadata(
      _encoded,
      new TypeMetadata('Map', arguments: [metadata.encodeType, metadata.modelType]),
      false,
      true,
      true,
      isFinal: true,
      defaultValue: enumeration.serializeAnnotation.mapping
  );

  generateField(field, buffer, generateFieldDeclaration, []);

  generateFunctionDefinition(
      metadata,
      buffer,
      _decoderGenerator,
      annotationGenerators: [generateUsing],
      useArrow: true
  );
}

void generateEnumEncoder(ConverterFunctionMetadata metadata,
                         EnumMetadata enumeration,
                         StringBuffer buffer)
{
  // Create the value declaration
  var field = new FieldMetadata(
      _decoded,
      new TypeMetadata('List', arguments: [metadata.encodeType]),
      false,
      true,
      true,
      isFinal: true,
      defaultValue: enumeration.serializeAnnotation.mapping.keys.toList()
  );

  generateField(field, buffer, generateFieldDeclaration, []);

  generateFunctionDefinition(
      metadata,
      buffer,
      _encoderGenerator,
      annotationGenerators: [generateUsing],
      useArrow: true
  );
}

/// Derives the encode function name for the given enumeration [name].
String encodeEnumFunction(String name) {
  return 'encode$name';
}

/// Derives the decode function name for the given enumeration [name].
String decodeEnumFunction(String name) {
  return 'decode$name';
}

void _decoderGenerator(FunctionMetadata metadata, StringBuffer buffer) {
  buffer.writeln('_encoded[value] ?? null;');
}

void _encoderGenerator(FunctionMetadata metadata, StringBuffer buffer) {
  buffer.writeln('_decoded[value.index];');
}
