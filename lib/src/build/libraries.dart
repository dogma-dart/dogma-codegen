// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.src.build.libraries;

import 'package:dogma_codegen/metadata.dart';

final LibraryMetadata dartConvert = new LibraryMetadata(
    'dart:convert',
    Uri.parse('dart:convert')
);

final LibraryMetadata dartCollection = new LibraryMetadata(
    'dart:collection',
    Uri.parse('dart:collection')
);

final LibraryMetadata dataSerialize = new LibraryMetadata(
    'dogma_data.serialize',
    Uri.parse('package:dogma_data/serialize.dart')
);

final LibraryMetadata dogmaData = new LibraryMetadata(
    'dogma_data',
    Uri.parse('package:dogma_data/data.dart')
);

LibraryMetadata packageLibrary(LibraryMetadata library) {
  // Check if the library is already a package library
  if (library.uri.scheme != 'file') {
    return library;
  }

  // Generate the package uri
  var joined = library.name.replaceAll('.', '/');
  var packageUri = Uri.parse('package:${joined}.dart');

  // Create a new library with everything the same but the uri
  return new LibraryMetadata(
      library.name,
      packageUri,
      imported: library.imported,
      exported: library.exported,
      models: library.models,
      enumerations: library.enumerations,
      converters: library.converters,
      functions: library.functions
  );
}
