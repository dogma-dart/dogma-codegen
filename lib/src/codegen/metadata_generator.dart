// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.src.codegen.field_generator;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';

import 'annotation_generator.dart';
import 'comment_generator.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

// \TODO Can get rid of if checks if Metadata is Annotated and Commented

/// Generates [metadata] for a declaration.
///
/// Checks to see if the [metadata] is [Commented] and if so writes out code
/// comments to the [buffer] when present. Also checks to see if the [metadata]
/// is [Annotated] and if so writes out annotations based on the functions in
/// [annotationGenerators].
void generateMetadata(Metadata metadata,
                      StringBuffer buffer,
                      List<AnnotationGenerator> annotationGenerators)
{
  // Write the comments out
  if (metadata is Commented) {
    var commented = metadata as Commented;

    generateCodeComment(commented.comments, buffer);
  }

  // Write out any annotations
  if (metadata is Annotated) {
    var annotated = metadata as Annotated;

    for (var annotation in annotated.annotations) {
      for (var annotationGenerator in annotationGenerators) {
        annotationGenerator(annotation, buffer);
      }
    }
  }
}
