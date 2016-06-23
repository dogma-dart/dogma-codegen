// Copyright (c) 2016, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:async';

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_source_analyzer/path.dart' as p;

import '../../build.dart';
import '../../io.dart';
import 'builder_config_convert.dart';
import 'input_set_convert.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Loads the configuration at the given [path].
///
/// This will return the individual build steps for the build.
Future<List<Map>> loadConfig(String path) async {
  var config = await readYaml/*<Map>*/(p.join(path), clone: true);

  return transformConfig(config);
}

/// Transforms the [input] configuration.
///
/// The transform is used to apply default values to the configuration that is
/// then used to deserialize the config.
List<Map> transformConfig(Map input) {
  // Get the defaults for a builder config
  var builderDefaults = input['defaults'] ?? {};

  // Iterate through the steps
  var steps = input['steps'] as List<Map> ?? <Map>[];

  for (var value in steps) {
    if (value.keys.length != 1) {
      throw new ArgumentError('Build step not properly configured');
    }

    // Get the step
    var name = value.keys.first;
    var step = value[name];

    // Apply the defaults
    _applyDefaults(step, builderDefaults);

    step[BuilderConfigDecoder.libraryOutputKey] ??= 'lib/src/$name';

    step[InputSetDecoder.inputPackageKey] ??= currentPackageName;
    step[InputSetDecoder.inputSetKey] =
        _stringList(step[InputSetDecoder.inputSetKey]);

    // Apply the target defaults
    var targetDefaults = step['defaults'] as Map ?? {};

    var targets = step['targets'] as Map ?? {};

    targets.forEach((_, targetValue) {
      _applyDefaults(targetValue, targetDefaults);
    });
  }

  return steps;
}

void _applyDefaults(Map value, Map defaults) {
  // Iterate over the map
  defaults.forEach((key, apply) {
    // See if the value needs to be applied recursively
    if (apply is Map) {
      value[key] ??= {};

      _applyDefaults(value[key], apply);
    } else {
      value[key] ??= apply;
    }
  });
}

List<String> _stringList(dynamic value) {
  if (value == null) {
    return <String>[];
  }

  if (value is String) {
    return <String>[value];
  } else if (value is List<String>) {
    return value;
  } else {
    throw new ArgumentError.value(value, 'Is not a String or List of String');
  }
}
