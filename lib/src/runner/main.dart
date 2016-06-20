// Copyright (c) 2016, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:async';
import 'dart:convert';

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:build/build.dart';
import 'package:logging/logging.dart';

import '../../build.dart';
import 'builder_manager.dart';
import 'config_file.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

Future<Null> main(List<String> args) async {
  // Start logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  // Create the manager
  var manager = new BuilderManager();

  // Register builders
  manager.autoRegisterBuilders();

  // Read the configuration file
  var config = await loadConfig('dogma.yaml');

  print(JSON.encode(config));

  // Create the builders and input sets
  var inputs = <InputSet>[];
  var builders = <SourceBuilder>[];

  for (var value in config) {
    assert(value.length == 1);
    var name = value.keys.first;
    var config = value[name];

    var builder = manager.createBuilder(name, config);

    builders.add(builder);
  }
}
