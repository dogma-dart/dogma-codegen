// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.src.build.models;

import 'dart:async';
import 'dart:io';

import 'package:dogma_codegen/codegen.dart';
import 'package:dogma_codegen/metadata.dart';
import 'package:dogma_codegen/template.dart';

Future<Null> writeModels(LibraryMetadata models) async {
  // Write the exported models
  for (var export in models.exported) {

  }
}

Future<Null> _writeModelLibrary(LibraryMetadata library) async {
  var file = new File(library.uri.toFilePath());

  if (await file.exists()) {
    var lines = await file.readAsLines();

    if (!isGeneratedSource(lines)) {
      return;
    }
  }

  await file.writeAsString(generateModelsLibrary(library));
}
