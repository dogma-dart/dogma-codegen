// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.src.codegen.utils;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';

import 'argument_buffer.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Generates the name for the [type] into the [buffer].
///
/// This supports recursive calls for generics.
String generateType(TypeMetadata type) {
  var buffer = new StringBuffer();

  buffer.write(type.name);

  // Look for generics
  var arguments = type.arguments;

  if (arguments.isNotEmpty) {
    buffer.write('<');

    var argumentBuffer = new ArgumentBuffer();

    for (var argument in arguments) {
      argumentBuffer.write(generateType(argument));
    }

    buffer.write(argumentBuffer.toString());
    buffer.write('>');
  }

  return buffer.toString();
}

/// Generates code to call the default constructor for the [type] into the [buffer].
String generateConstructorCall(TypeMetadata type)
    => 'new ${generateType(type)}()';
