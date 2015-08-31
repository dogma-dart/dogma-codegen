// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains functions to write out class declarations.
library dogma_codegen.src.codegen.class_generator;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';

import 'argument_buffer.dart';
import 'type_generator.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

void generateClassDeclaration(ClassMetadata metadata, StringBuffer buffer) {
  buffer.write('class ');
  buffer.write(generateType(metadata.type));

  // Write the extends clause if necessary
  var supertype = metadata.supertype;

  if (supertype != null) {
    buffer.write(' extends ');
    buffer.write(generateType(supertype));
  }

  // Write the implements clause if necessary
  var implements = metadata.implements;

  if (implements.isNotEmpty) {
    buffer.write(' implements ');

    var argumentBuffer = new ArgumentBuffer();

    for (var implementation in implements) {
      argumentBuffer.write(generateType(implementation));
    }

    buffer.write(argumentBuffer.toString());
  }
}
