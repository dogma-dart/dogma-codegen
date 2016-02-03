// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.src.build.models;

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:async';

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:logging/logging.dart';

import '../../metadata.dart';

import 'io.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// The logger for the library.
final Logger _logger = new Logger('dogma_codegen.src.build.models');

/// Writes the [models] library to disk.
///
/// The value of [models] should be the root library which exports the others.
Future<Null> writeModels(LibraryMetadata models) async {
  for (var export in models.exported) {
    _logger.info('Writing ${export.name} to disk at ${export.uri}');
    await writeModelsLibrary(export);
  }

  _logger.info('Writing ${models.name} to disk at ${models.uri}');
  await writeRootLibrary(models);
}
