// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [AnnotatedMetadata] class.
library dogma_codegen.src.metadata.annotated_metadata;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'annotated.dart';
import 'commented.dart';
import 'metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Metadata that contains annotations.
class AnnotatedMetadata extends Metadata implements Annotated, Commented {
  //---------------------------------------------------------------------
  // Annotated
  //---------------------------------------------------------------------

  @override
  final List annotations;

  //---------------------------------------------------------------------
  // Commented
  //---------------------------------------------------------------------

  @override
  final String comments;

  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Creates an instance of [AnnotatedMetadata] with the given [name].
  ///
  /// Annotations are contained in the [annotations] array. These are a list of
  /// annotations that have been constructed.
  ///
  /// Any code [comments] are present in that value.
  AnnotatedMetadata(String name, this.annotations, this.comments)
      : super(name);
}
