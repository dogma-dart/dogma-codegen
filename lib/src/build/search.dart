// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:cli_util/cli_util.dart';
import 'package:dogma_codegen/analyzer.dart';
import 'package:dogma_codegen/metadata.dart';
import 'package:dogma_codegen/io.dart';
import 'package:dogma_codegen/path.dart';
import 'package:dogma_codegen/template.dart';

/// Finds all user defined libraries within the [path].
Stream<LibraryMetadata> findUserDefinedLibraries(Uri path) async* {
  // \TODO USE URI
  var directoryExists = await createDirectory(path.toFilePath());
  var userDefinedLibraries = [];

  // Search through the directory for converters
  if (directoryExists) {
    var context = analysisContext(currentPath, getSdkDir().path);
    var directory = new Directory(path.toFilePath());

    await for (var value in directory.list(recursive: false, followLinks: false)) {
      if (value is File) {
        var lines = await value.readAsLines();

        if (!isGeneratedSource(lines)) {
          yield libraryMetadata(value.path, context);
        }
      }
    }
  }
}
