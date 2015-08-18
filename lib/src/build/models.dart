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

import 'package:dogma_codegen/io.dart';
import 'package:dogma_codegen/metadata.dart';

import 'search.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

Future<Null> buildModels(LibraryMetadata models,
                         Uri sourcePath) async
{
  await for (var library in findUserDefinedLibraries(sourcePath)) {
    print(library.uri);
  }

  for (var export in models.exported) {
    await writeModelsLibrary(export);
  }

  await writeRootLibrary(models);
}
