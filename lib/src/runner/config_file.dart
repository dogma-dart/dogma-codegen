// Copyright (c) 2016, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:async';
import 'dart:io';

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_source_analyzer/path.dart' as p;

import '../../build.dart';
import '../../io.dart';
import 'builder_config_convert.dart';
import 'formatter_config_convert.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Loads the configuration at the given [path].
Future<Map> loadConfig(String path) async {
  var config = await readYaml/*<Map>*/(p.join(path));

  return transformConfig(config);
}

/// Transforms the [input] configuration.
///
/// The transform is used to apply default values to the configuration that is
/// then used to deserialize the config.
Map transformConfig(Map input) {
  var output = {};

  // Get the default values
  var defaults = _getDefaults(input);

  // Run through the steps
  var steps = input['steps'] as List<Map>;
  var previousStep;

  for (var value in steps) {
    // Should contain a single key and value
    assert(value.keys.length == 1);

    // Get the name and step
    var name = value.keys.first;
    var step = value[name] as Map;

    // Apply global defaults
    _applyDefaults(step, defaults);

    step['input_package'] ??= currentPackageName;
    step[BuilderConfigDecoder.outputLibraryNameKey] ??= 'lib/src/$name';

    // Set the input step
    var inputSet = _parseInputSet(step['input_set']);

    // See if the previous step should apply
    if (inputSet.isEmpty) {
      assert(previousStep != null);

      inputSet.add('${previousStep[BuilderConfigDecoder.outputLibraryNameKey]}/*.dart');
    }

    step['input_set'] = inputSet;

    // Set the previous step
    previousStep = step;
  }

  return output;
}

/// Applies the [defaults] to the [step].
void _applyDefaults(Map step, Map defaults) {
  step[BuilderConfigDecoder.copyrightKey] ??= defaults[BuilderConfigDecoder.copyrightKey];
  step[BuilderConfigDecoder.outputLibraryNameKey] ??= defaults[BuilderConfigDecoder.outputLibraryNameKey];

  var formatter = step[BuilderConfigDecoder.formatterKey];

  if (formatter == null) {
    step[BuilderConfigDecoder.formatterKey] = defaults[BuilderConfigDecoder.formatterKey];
  } else {
    var formatterDefaults = defaults[BuilderConfigDecoder.formatterKey];

    formatter[FormatterConfigDecoder.lineEndingKey] ??= formatterDefaults[FormatterConfigDecoder.lineEndingKey];
    formatter[FormatterConfigDecoder.pageWidthKey] ??= formatterDefaults[FormatterConfigDecoder.pageWidthKey];
    formatter[FormatterConfigDecoder.indentKey] ??= formatterDefaults[FormatterConfigDecoder.indentKey];
  }
}

/// Gets the defaults for the [input].
///
/// This is used to get the default values that should be applied to each
/// individual step.
Map _getDefaults(Map input) {
  var defaults = input['defaults'] ?? {};

  defaults[BuilderConfigDecoder.copyrightKey] ??= '';
  defaults[BuilderConfigDecoder.outputLibraryNameKey] ??= false;

  // Create the formatter
  var formatter = defaults[BuilderConfigDecoder.formatterKey] ?? {};

  formatter[FormatterConfigDecoder.lineEndingKey] ??= Platform.isWindows ? '\n' : '\r\n';
  formatter[FormatterConfigDecoder.pageWidthKey] ??= 80;
  formatter[FormatterConfigDecoder.indentKey] ??= 0;

  defaults[BuilderConfigDecoder.formatterKey] = formatter;

  return defaults;
}

/// Parses an input set from the [value].
///
/// The config allows input sets to be specified as a list of string or just
/// a string. This handles transforming the values.
List<String> _parseInputSet(dynamic value) {
  if (value == null) {
    return <String>[];
  } else if (value is String) {
    return <String>[value];
  } else {
    assert(value is List);
    return value as List<String>;
  }
}
