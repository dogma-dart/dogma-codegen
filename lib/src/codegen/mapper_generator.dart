// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.src.codegen.mapper_generator;

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
  generateClassDefinition(metadata, buffer, _generateMapperDefinition);
}

void _generateMapperDefinition(ClassMetadata metadata, StringBuffer buffer) {
  var mapper = metadata as MapperMetadata;
}
