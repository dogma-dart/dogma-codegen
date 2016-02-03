// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.src.build.libraries;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import '../../metadata.dart';
import '../../path.dart' as p;

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

/// The dogma_convert.serialize library.
///
/// This is required when generating code that uses the Serialize annotation.
final LibraryMetadata dogmaSerialize = new LibraryMetadata(
    'dogma_convert.serialize',
    Uri.parse('package:dogma_convert/serialize.dart')
);

/// The dogma_convert.convert library.
///
/// This is required for generated Converters.
final LibraryMetadata dogmaConvert = new LibraryMetadata(
    'dogma_convert.convert',
    Uri.parse('package:dogma_convert/convert.dart')
);

/// The dogma_connection.connection library.
///
/// This is required for generated Mappers.
final LibraryMetadata dogmaConnection = new LibraryMetadata(
    'dogma_connection.connection',
    Uri.parse('package:dogma_connection/connection.dart')
);

/// The dogma_mapper.mapper library.
///
/// This is required for generated Mappers.
final LibraryMetadata dogmaMapper = new LibraryMetadata(
    'dogma_mapper.mapper',
    Uri.parse('package:dogma_mapper/mapper.dart')
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

  // Check if the library is in the lib directory
  if (!p.isWithin(p.join('lib'), library.uri)) {
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
      classes: library.classes,
      functions: library.functions,
      fields: library.fields
  );
}
