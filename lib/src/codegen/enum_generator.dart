// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains functions to write out the declaration of an enum.
library dogma_codegen.src.codegen.enum_generator;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';

import 'argument_buffer.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

void generateEnum(EnumMetadata enumeration, StringBuffer buffer) {
  // Get the names
  var name = enumeration.name;

  // Write out the encoding if necessary
  if (enumeration.explicitSerialization) {
    var encoded = enumeration.encoded;
    var values = enumeration.values;
    var count = values.length;
    var isString = encoded[0] is String;
    var argumentBuffer = new ArgumentBuffer.lineBreak();

    for (var i = 0; i < count; ++i) {
      var encode = encoded[i];

      if (isString) {
        encode = '\'$encode\'';
      }

      argumentBuffer.write('$encode: $name.${values[i]}');
    }

    buffer.writeln('@Serialize.values(const {');
    buffer.writeln(argumentBuffer.toString());
    buffer.writeln('})');
  }

  // Write the enum declaration
  buffer.writeln('enum $name {');

  // Write the enumeration values out.
  var valueBuffer = new ArgumentBuffer.lineBreak();

  for (var value in enumeration.values) {
    valueBuffer.write(value);
  }

  buffer.writeln(valueBuffer.toString());

  // Close the class declaration
  buffer.writeln('}');
}
