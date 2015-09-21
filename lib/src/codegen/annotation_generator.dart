// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.src.codegen.annotation_generator;

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Definition of a function that generates annotations.
///
/// The generator should test the type of [value] to determine if the annoation
/// declaration should be written to the [buffer].
typedef void AnnotationGenerator(dynamic value, StringBuffer buffer);

/// Generates the @override annotation into the [buffer] if the [value] is
/// equal to [override].
void generateOverrideAnnotation(dynamic value, StringBuffer buffer) {
  if (value == override) {
    buffer.writeln('@override');
  }
}
