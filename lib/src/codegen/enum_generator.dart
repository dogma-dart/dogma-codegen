// Copyright (c) 2015-2016 the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/*
//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import '../../metadata.dart';

import 'annotation_generator.dart';
import 'class_generator.dart';
import 'field_generator.dart';
import 'serialize_annotation_generator.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

void generateEnum(EnumMetadata enumeration, StringBuffer buffer) {
  var annotationGenerators = <AnnotationGenerator>[];

  // Write out the encoding if necessary
  if (enumeration.explicitSerialization) {
    annotationGenerators.add(generateValuesAnnotation);
  }

  generateClassDefinition(
      enumeration,
      buffer,
      _generateEnumDefinition,
      annotationGenerators: annotationGenerators
  );
}

void _generateEnumDefinition(Metadata metadata, StringBuffer buffer) {
  var enumeration = metadata as EnumMetadata;

  generateFields(enumeration.fields, buffer, generator: (field, buf) {
    buffer.write('${field.name},');
  });
}
*/
