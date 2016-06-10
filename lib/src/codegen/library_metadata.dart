// Copyright (c) 2015-2016 the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_source_analyzer/metadata.dart';

import 'annotated_metadata.dart';
import 'annotation.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Generates the library declaration from the [metadata] into the [buffer].
void generateLibraryDeclaration(LibraryMetadata metadata,
                                StringBuffer buffer,
                               {List<AnnotationGenerator> annotationGenerators}) {
  generateAnnotatedMetadata(metadata, buffer, annotationGenerators);

  var name = metadata.name;

  if (name.isEmpty) {
    name = 'test';
  }

  buffer.writeln('library $name');
}
