// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.src.build.libraries;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// The dart:convert library.
///
/// This is required for generated converters as they implement Converter.
final LibraryMetadata dartConvert = new LibraryMetadata(
    'dart:convert',
    Uri.parse('dart:convert')
);

/// The dart:collection library.
///
/// This is required when UnmodifiableListView or UnmodifiableMapView are
/// needed for unmodifiable views over models.
final LibraryMetadata dartCollection = new LibraryMetadata(
    'dart:collection',
    Uri.parse('dart:collection')
);

/// The dogma_data.serialize library.
///
/// This is required when generating code that uses the Serialize annotation.
final LibraryMetadata dogmaSerialize = new LibraryMetadata(
    'dogma_data.serialize',
    Uri.parse('package:dogma_data/serialize.dart')
);

/// The dogma_data.data library.
///
/// This is required for generated Converters.
final LibraryMetadata dogmaData = new LibraryMetadata(
    'dogma_data.data',
    Uri.parse('package:dogma_data/data.dart')
);

/// Converts a library from a file URI into a package URI.
///
/// Will just return the library if it is already either a dart or package
/// library.
LibraryMetadata packageLibrary(LibraryMetadata library) {
  // Check if the library is already a package library
  if (library.uri.scheme != 'file') {
    return library;
  }

  // Generate the package uri
  var joined = library.name.replaceAll('.', '/');
  var packageUri = Uri.parse('package:$joined.dart');

  // Create a new library with everything the same but the uri
  return new LibraryMetadata(
      library.name,
      packageUri,
      imported: library.imported,
      exported: library.exported,
      models: library.models,
      enumerations: library.enumerations,
      converters: library.converters,
      functions: library.functions,
      mappers: library.mappers
  );
}
