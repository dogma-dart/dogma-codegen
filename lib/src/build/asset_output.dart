// Copyright (c) 2016, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:build/build.dart';
import 'package:dogma_source_analyzer/path.dart' as p;
import 'package:meta/meta.dart';

import 'configurable.dart';
import 'target_config.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Contains methods which transform input paths and file names.
abstract class AssetOutput<T extends TargetConfig> implements Configurable<T> {
  /// Gets the output asset id from the [input].
  AssetId outputAssetId(AssetId input) =>
      new AssetId(package, assetPath(input.path));

  /// Gets the path to an outputted asset from the given [input].
  @protected
  String assetPath(String input) {
    var base = filename(p.basename(input));

    return '${config.libraryOutput}/$base';
  }

  /// Gets the modified filename for the step from the [input].
  ///
  /// The [input] is expected to just be the filename.
  ///
  /// If the file name should be modified then this should be overridden.
  @protected
  String filename(String input) => input;
}
