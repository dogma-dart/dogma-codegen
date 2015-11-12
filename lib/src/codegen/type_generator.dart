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

/// Generates the name for the [type].
///
/// This supports recursive calls for generics.
String generateType(TypeMetadata type)
    => '${type.name}${generateTypeArguments(type)}';

/// Generates the arguments for the [type].
///
/// This supports recursive calls for generics.
String generateTypeArguments(TypeMetadata type) {
  var buffer = new StringBuffer();

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

/// Generates code to call the default constructor for the [type].
///
/// For List and Map types the calls will follow the style guide for their
/// respective declarations.
///
///     var numList = <num>[];
///     var stringFooMap = <String,Foo>{};
String generateConstructorCall(TypeMetadata type) {
  if (type.isList) {
    return '${generateTypeArguments(type)}[]';
  } else if (type.isMap) {
    return '${generateTypeArguments(type)}{}';
  } else {
    return 'new ${generateType(type)}()';
  }
}

/// Generates code to produce a cast for the [type].
String generateCast(TypeMetadata type)
    => 'as ${generateType(type)}';
