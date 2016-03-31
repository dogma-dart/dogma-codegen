// Copyright (c) 2015-2016, the Dogma Project Authors.
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

import 'package:yaml/yaml.dart';

import 'resource.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Reads the contents of a YAML resource at the [uri].
///
/// The output of the yaml library is unmodifiable. If modification of the
/// output is required then [clone] should be set to true.
Future<dynamic /*=T*/> readYaml/*<T>*/(Uri uri, {bool clone: false}) async {
  var contents = await readResource(uri);
  var value = loadYaml(contents) as dynamic /*=T*/;

  return clone ? _cloneYaml/*<T>*/(value) : value;
}

/// Clones the output of [yaml].
///
/// This function recursively goes through a yaml file and performs a deep copy
/// of the data.
dynamic/*=T*/ _cloneYaml/*<T>*/(dynamic yaml) {
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

  return value as dynamic /*=T*/;
}
