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

/// Contains configuration for source builders.
abstract class Configurable<T extends TargetConfig> {
  /// The name of the package to output into.
  String get package;
  /// The configuration for the builder.
  BuilderConfig<T> get config;

  /// Retrieve the target config for the [name].
  ///
  /// If the [name] is not present in the [config] then the default value is
  /// returned instead.
  T getTargetConfig(String name) =>
      config.targets[name] ?? config.defaultTarget;
}
