// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.src.codegen.serialize_annotation_generator;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_data/serialize.dart';

import 'argument_buffer.dart';
import 'builtin_generator.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Generates a serialize [annotation] for a field.
///
/// The generated string will only have values that differ from the default
/// named parameters of [Serialize.field].
void generateFieldAnnotation(dynamic annotation, StringBuffer buffer) {
  if (annotation is! Serialize) {
    return;
  }

  var name = annotation.name;
  var argumentBuffer = new ArgumentBuffer();

  // Write the name
  argumentBuffer.write(generateString(name));

  // Get the default values
  var defaults = new Serialize.field(name);

  // See if decode is set to the default
  var decode = annotation.decode;

  if (decode != defaults.decode) {
    argumentBuffer.write('decode: $decode');
  }

  // See if encode is set to the default
  var encode = annotation.encode;

  if (encode != defaults.encode) {
    argumentBuffer.write('encode: $encode');
  }

  // See if optional is set to the default
  var optional = annotation.optional;

  if (optional != defaults.optional) {
    argumentBuffer.write('optional: $optional');
  }

  // See if defaultsTo is set to the default
  var defaultsTo = annotation.defaultsTo;

  if (defaultsTo != defaults.defaultsTo) {
    var value;

    if (defaultsTo is String) {
      value = generateString(defaultsTo);
    } else if (defaultsTo is List) {
      value = 'const []';
    } else if (defaultsTo is Map) {
      value = 'const {}';
    } else {
      value = defaultsTo;
    }

    argumentBuffer.write('defaultsTo: $value');
  }

  // Write out the declaration
  buffer.writeln('@Serialize.field(${argumentBuffer.toString()})');
}

void generateFieldMapping(dynamic annotation, StringBuffer buffer) {
  if (annotation is! Serialize) {
    return;
  }

  buffer.write('@Serialize.values(');
  buffer.write(generateMap(annotation.mapping, true, true));
  buffer.writeln(')');
}

void generateUsing(dynamic annotation, StringBuffer buffer) {
  if (annotation == Serialize.using) {
    buffer.writeln('@Serialize.using');
  }
}
