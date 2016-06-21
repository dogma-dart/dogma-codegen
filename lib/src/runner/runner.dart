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

import 'package:build/build.dart';
import 'package:logging/logging.dart';

import '../../build.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

final Logger _logger = new Logger('dogma_codegen.src.runner.runner');

/// Builds the project defined in the [phases].
///
/// A [reader] and [writer] can be provided explicitly. If they are not the
/// file based reader/writer is used.
Future<Null> buildProject(PhaseGroup phases,
                         {AssetReader reader,
                          AssetWriter writer,
                          bool watcher: false,
                          bool deleteFilesByDefault: true,
                          Level logLevel: Level.INFO}) async {
  reader ??= new FileBasedAssetReader(currentPackageGraph);
  writer ??= new FileBasedAssetWriter(currentPackageGraph);

  if (watcher) {
    var results = watch(
        phases,
        deleteFilesByDefault: deleteFilesByDefault,
        reader: reader,
        writer: writer,
        logLevel: logLevel
    );

    await for (var result in results) {
      _logger.info('Build completed ${result.status}');
    }
  } else {
    var result = await build(
        phases,
        deleteFilesByDefault: deleteFilesByDefault,
        reader: reader,
        writer: writer,
        logLevel: logLevel
    );

    _logger.info('Build completed ${result.status}');
  }
}

/// Creates a phase group from the list of [builders] and their corresponding
/// [inputs].
PhaseGroup createPhases(List<SourceBuilder> builders, List<InputSet> inputs) {
  var builderCount = builders.length;

  if (builderCount != inputs.length) {
    throw new ArgumentError('The number of builders does not match the number of inputs');
  }

  var phases = new PhaseGroup();

  for (var i = 0; i < builderCount; ++i) {
    phases.addPhase(new Phase()..addAction(builders[i], inputs[i]));
  }

  return phases;
}
