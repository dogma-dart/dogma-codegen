// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.src.codegen.enum_converter_generator;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';

import 'class_generator.dart';
import 'type_generator.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Writes out the class definition for a mapper using the [metadata].
void generateMapper(MapperMetadata metadata, StringBuffer buffer) {
  var name = metadata.name;
  var modelName = metadata.type.name;

  // Write the class declaration
  generateClassDeclaration(metadata, buffer);

  // Write the default constructor
  buffer.writeln('$name()');
  _writeSuperConstructor(
      'new ${metadata.decoder.name}()',
      'new ${metadata.encoder.name}()',
      buffer
  );

  // Write the other constructor
  // \TODO

  buffer.writeln('}');
}

void _writeSuperConstructor(String decoder, String encoder, StringBuffer buffer) {
  buffer.writeln(': super(connection, decoder: $decoder, encoder: $encoder);');
}
