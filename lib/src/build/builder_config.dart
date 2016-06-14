// Copyright (c) 2016, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'formatter_config.dart';
import 'target_config.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Configuration for a SourceBuilder.
class BuilderConfig {
  /// The output directory for the build target.
  String libraryOutput;
  /// The copyright information to output within the built file.
  String copyright;
  /// Whether library names should be outputted.
  String outputLibraryName;
  /// The configuration for the Dart formatter.
  FormatterConfig formatterConfig;
  /// Individual configurations for build targets.
  Map<String, TargetConfig> targets;
}
