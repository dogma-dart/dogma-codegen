// Copyright (c) 2015-2016, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_source_analyzer/metadata.dart';

import 'annotation.dart';
import 'comments.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Generates [metadata] for a declaration.
///
/// Checks to see if the [metadata] is [Commented] and if so writes out code
/// comments to the [buffer] when present. Also checks to see if the [metadata]
/// is [Annotated] and if so writes out annotations based on the functions in
/// [annotationGenerators].
void generateAnnotatedMetadata(AnnotatedMetadata metadata,
                               StringBuffer buffer,
                               List<AnnotationGenerator> annotationGenerators)
{
  // Write the comments out
  generateCodeComment(metadata.comments, buffer);

  // Write out any annotations
  for (var annotation in metadata.annotations) {
    for (var annotationGenerator in annotationGenerators) {
      annotationGenerator(annotation, buffer);
    }
  }
}
