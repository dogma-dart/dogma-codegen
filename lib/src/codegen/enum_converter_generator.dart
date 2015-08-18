// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.src.codegen.enum_converter_generator;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';

import 'argument_buffer.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Name for the map containing decoded values
const String _decoded = '_decoded';
/// Name for the list containing encoded values.
const String _encoded = '_encoded';
/// Name for the defaults to parameter.
const String _defaultsTo = 'defaultsTo';

void generateEnumDecoder(EnumMetadata metadata, StringBuffer buffer) {
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
  var argumentBuffer = new ArgumentBuffer();

  for (var i = 0; i < valueCount; ++i) {
    var encode = encoded[i];

    if (isString) {
      encode = '\'$encode\'';
    }

    argumentBuffer.write('$encode: $name.${values[i]}');
  }

  buffer.writeln('final Map<$encodeType, $name> $_decoded = {');
  buffer.writeln(argumentBuffer.toString());
  buffer.writeln('};\n');

  // Write out the decode function
  buffer.writeln('@Serialize.decodeThrough');
  buffer.writeln('$name ${decodeEnumFunction(name)}($encodeType value, [$name $_defaultsTo = $name.${values[0]}]) {');
  buffer.writeln('return $_decoded[value] ?? $_defaultsTo;');
  buffer.writeln('}');
}

void generateEnumEncoder(EnumMetadata metadata, StringBuffer buffer) {
  // Get the name
  var name = metadata.name;

  // Get the values
  var values = metadata.values;
  var valueCount = values.length;

  // Determine the encoding
  var encoded = metadata.encoded;
  var encodeType = encoded[0].runtimeType.toString();
  var isString = encoded[0] is String;

  // Write out the encoding list
  var argumentBuffer = new ArgumentBuffer.lineBreak();

  for (var i = 0; i < valueCount; ++i) {
    var encode = encoded[i];

    if (isString) {
      encode = '\'$encode\'';
    }

    argumentBuffer.write(encode);
  }

  buffer.writeln('final List<$encodeType> $_encoded = [');
  buffer.writeln(argumentBuffer.toString());
  buffer.writeln('];\n');

  // Write out the encode function
  buffer.writeln('@Serialize.encodeThrough');
  buffer.writeln('$encodeType ${encodeEnumFunction(name)}($name value) {');
  buffer.writeln('return $_encoded[value.index];');
  buffer.writeln('}');
}

/// Derives the encode function name for the given enumeration [name].
String encodeEnumFunction(String name) {
  return 'encode$name';
}

/// Derives the decode function name for the given enumeration [name].
String decodeEnumFunction(String name) {
  return 'decode$name';
}
