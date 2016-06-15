// Copyright (c) 2016, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Configuration for an output of the SourceBuilder.
class TargetConfig {
  /// Comments for the target.
  ///
  /// This can be used to provide explicit code comments for the generated
  /// structure.
  String comments;
  /// Whether the target should not be outputted.
  bool exclude;
}
