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
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The default value for [copyright].
  static const String copyrightDefault = '';
  /// The default value for [outputLibraryDirective].
  static const bool outputLibraryDirectiveDefault = false;
  /// The default value for [outputBuildTimestamps].
  static const bool outputBuildTimestampsDefault = true;

  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// The output directory for the build target.
  String libraryOutput = '';
  /// The copyright information to output within the built file.
  String copyright = copyrightDefault;
  /// Whether library directives should always be outputted.
  ///
  /// The library directive is currently optional. By setting the value to
  /// `true` it will always be outputted even in cases where it is not
  /// required.
  bool outputLibraryDirective = outputLibraryDirectiveDefault;
  /// Whether the timestamp should be added to built files.
  ///
  /// This should be false when the generated files are checked into a
  /// repository.
  bool outputBuildTimestamps = outputBuildTimestampsDefault;
  /// The configuration for the Dart formatter.
  FormatterConfig formatterConfig = new FormatterConfig();
  /// Individual configurations for build targets.
  Map<String, TargetConfig> targets = <String, TargetConfig>{};
}
