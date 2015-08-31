// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains functions to parse files.
///
/// Currently supports reading JSON and YAML files.
library dogma_codegen.src.build.parse;

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:async';
import 'dart:convert';
import 'dart:io';

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:yaml/yaml.dart';
import 'package:dogma_codegen/path.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Reads the contents of a JSON file at the [path].
Future<dynamic> jsonFile(dynamic path) async {
  var contents = await _readFile(path);

  return JSON.decode(contents);
}

/// Reads the contents of a YAML file at the [path].
///
/// The output of the yaml library is unmodifiable. If modification of the
/// output is required then [clone] should be set to true.
Future<dynamic> yamlFile(dynamic path, {bool clone: false}) async {
  var contents = await _readFile(path);
  var value = loadYaml(contents);

  return clone ? _cloneYaml(value) : value;
}

/// Gets the contents of a file at the given [path].
Future<String> _readFile(String path) {
  var uri = join(path);

  var file = new File(uri.toFilePath());

  return file.readAsString();
}

/// Clones the output of [yaml].
///
/// This function recursively goes through a yaml file and performs a deep copy
/// of the data.
dynamic _cloneYaml(dynamic yaml) {
  var value;

  if (yaml is Map) {
    value = {};

    yaml.forEach((k, v) {
      value[k] = _cloneYaml(v);
    });
  } else if (yaml is List) {
    value = [];

    for (var v in yaml) {
      value.add(_cloneYaml(v));
    }
  } else {
    value = yaml;
  }

  return value;
}
