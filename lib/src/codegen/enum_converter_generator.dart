// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.src.codegen.enum_converter_generator;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Name for the map containing decoded values
const String _decoded = '_decoded';
/// Name for the list containing encoded values.
const String _encoded = '_encoded';

void generateEnumDecoder(EnumMetadata metadata, StringBuffer buffer) {

}

void generateEnumEncoder(EnumMetadata metadata, StringBuffer buffer) {

}

/// Writes out the converters for an enumeration with the given [metadata].
///
/// For enumerations a set of functions are generated to provide the
/// conversion. For decoding this is backed by a map which
String generateEnumConverter(EnumMetadata metadata) {
  var buffer = new StringBuffer();

  // Get the name
  var name = metadata.name;

  // Get the values
  var values = metadata.values;
  var valueCount = values.length;

  // Determine the encoding
  var encoded = metadata.encoded;
  var encodeType = encoded[0].runtimeType.toString();
  var isString = encoded[0] is String;

  // Write out the decoding map
  buffer.writeln('final Map<$encodeType, $name> $_decoded = {');

  for (var i = 0; i < valueCount; ++i) {
    var encode = encoded[i];

    if (isString) {
      encode = '\'$encode\'';
    }

    buffer.writeln('$encode: $name.${values[i]},');
  }

  buffer.writeln('};\n');

  // Write out the decode function
  buffer.writeln('$name ${decodeEnumFunction(name)}($encodeType value, [$name defaultTo = $name.${values[0]}]) {');
  buffer.writeln('return $_decoded[value] ?? defaultTo;');
  buffer.writeln('}');

  // Write out the encoding list
  buffer.writeln('final List<$encodeType> $_encoded = [');

  for (var i = 0; i < valueCount; ++i) {
    var encode = encoded[i];

    if (isString) {
      encode = '\'$encode\'';
    }

    buffer.writeln('$encode,');
  }
  buffer.writeln('];\n');

  // Write out the encode function
  buffer.writeln('$encodeType ${encodeEnumFunction(name)}($name value) {');
  buffer.writeln('return $_encoded[value.index];');
  buffer.writeln('}');

  return buffer.toString();
}

/// Derives the encode function name for the given enumeration [name].
String encodeEnumFunction(String name) {
  return 'encode$name';
}

/// Derives the decode function name for the given enumeration [name].
String decodeEnumFunction(String name) {
  return 'decode$name';
}
