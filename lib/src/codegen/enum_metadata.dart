// Copyright (c) 2015-2016 the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_source_analyzer/metadata.dart';

import 'annotation.dart';
import 'argument_buffer.dart';
import 'class_metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Generates the values of an enumeration from the [metadata] into the
/// [buffer].
void generateEnumValues(ClassMetadata metadata, StringBuffer buffer) {
  var enumeration = metadata as EnumMetadata;
  var enumNames = enumeration.values.map((value) => value.name);

  writeArgumentsToBuffer(enumNames, buffer);
}

/// Generates an enum definition from the [metadata] into the buffer.
///
/// Any annotations that are present on the [metadata] are passed to the
/// [annotationGenerators].
///
/// This just acts as a wrapper around [generateClassDefinition].
void generateEnumDefinition(ClassMetadata metadata,
                            StringBuffer buffer,
                           {List<AnnotationGenerator> annotationGenerators}) {
  generateClassDefinition(
      metadata,
      buffer,
      generateEnumValues,
      annotationGenerators: annotationGenerators
  );
}
