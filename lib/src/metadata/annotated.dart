// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [Annotated] class.
library dogma_codegen.src.metadata.annotated;

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Interface for metadata containing annotations.
abstract class Annotated {
  /// The list of annotations.
  List get annotations;
}
