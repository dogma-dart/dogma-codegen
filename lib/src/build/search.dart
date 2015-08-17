// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:dogma_codegen/metadata.dart';
import 'package:dogma_codegen/io.dart';

/// Finds all user defined libraries within the [directory].
Stream<LibraryMetadata> findUserDefinedLibraries(Uri directory) async* {
  // \TODO USE URI
  var directoryExists = await createDirectory(directory.toFilePath());
  var userDefinedLibraries = new Map<String, LibraryMetadata>();

  // Search through the directory for converters
  if (directoryExists) {

    // Iterate over the values and push them to the stream
    for (var library in userDefinedLibraries.values) {
      yield library;
    }
  }
}
