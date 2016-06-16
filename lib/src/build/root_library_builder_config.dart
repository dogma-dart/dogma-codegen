// Copyright (c) 2016, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'builder_config.dart';
import 'target_config.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Configuration for a RootLibraryBuilder.
class RootLibraryBuilderConfig extends BuilderConfig<TargetConfig> {
  /// The relative path to the library.
  String libraryPath;
  /// The relative path to the directory containing the sources for the library.
  String sourceDirectory;
}
