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

import 'annotation_generator.dart';
import 'class_generator.dart';
import 'field_generator.dart';
import 'serialize_annotation_generator.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

void generateEnum(EnumMetadata enumeration, StringBuffer buffer) {
  var annotationGenerators = new List<AnnotationGenerator>();

  // Write out the encoding if necessary
  if (enumeration.explicitSerialization) {
    annotationGenerators.add(generateFieldMapping);
  }

  generateClassDefinition(
      enumeration,
      buffer,
      _generateEnumDefinition,
      annotationGenerators: annotationGenerators
  );
}

void _generateEnumDefinition(EnumMetadata enumeration, StringBuffer buffer) {
  generateFields(enumeration.fields, buffer, generator: (field, buf) {
    buffer.write('${field.name},');
  });
}
