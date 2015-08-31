// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [Commented] interface.
library dogma_codegen.src.metadata.commented;

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Interface for metadata containing comments.
abstract class Commented {
  /// The documentation comments describing the API.
  String get comments;
}
