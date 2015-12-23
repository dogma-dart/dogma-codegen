// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.src.build.mappers;

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:async';

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';
import 'package:dogma_codegen/path.dart';
import 'package:logging/logging.dart';

import 'libraries.dart';
import 'list.dart';
import 'io.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// The logger for the library.
final Logger _logger = new Logger('dogma_codegen.src.build.mappers');

Future<Null> buildMappers(LibraryMetadata models,
                          Uri libraryPath,
                          Uri sourcePath) async {
  // Search for any user defined libraries
  //var userDefined = <LibraryMetadata>[];

  // Create the equivalent library
  var mapper = mappersLibrary(
      models,
      libraryPath,
      sourcePath
  );

  await writeMapper(mapper);
}

/// Writes the [mapper] library to disk.
///
/// The value of [mapper] should be the root library which exports the others.
Future<Null> writeMapper(LibraryMetadata mapper) async {
  for (var export in mapper.exported) {
    _logger.info('Writing ${export.name} to disk at ${export.uri}');
    await writeMappersLibrary(export);
  }

  _logger.info('Writing ${mapper.name} to disk at ${mapper.uri}');
  await writeRootLibrary(mapper);
}

LibraryMetadata mappersLibrary(LibraryMetadata modelLibrary,
                               Uri libraryPath,
                               Uri sourcePath) {
  // \TODO standard thing for this???
  var packageName = modelLibrary.name.split('.')[0];

  // Convert the modelLibrary into the equivalent using package notation.
  modelLibrary = packageLibrary(modelLibrary);

  // Get the exported libraries
  var exported = <LibraryMetadata>[];
  var loaded = <String, LibraryMetadata>{};

  for (var export in modelLibrary.exported) {
    addIfNotNull(exported, _mappersLibrary(
        export,
        modelLibrary,
        packageName,
        sourcePath,
        loaded,
        <LibraryMetadata>[]
    ));
  }

  // Get the package name from the library
  var name = libraryName(packageName, libraryPath);

  return new LibraryMetadata(name, libraryPath, exported: exported);
}

LibraryMetadata _mappersLibrary(LibraryMetadata library,
                                LibraryMetadata modelLibrary,
                                String packageName,
                                Uri sourcePath,
                                Map<String, LibraryMetadata> loaded,
                                List<LibraryMetadata> userDefined) {
  // \TODO this is common
  // Check to see if the library was already loaded
  var loadingName = library.name;

  if (loaded.containsKey(loadingName)) {
    return loaded[loadingName];
  }

  // Include the libraries
  var imported = <LibraryMetadata>[
      dogmaConnection,
      dogmaMapper,
      modelLibrary
  ];

  // Create the mappers
  var mappers = <MapperMetadata>[];

  for (var model in library.models) {
    mappers.add(new MapperMetadata.type(model.type));
  }

  if (mappers.isEmpty) {
    return null;
  }

  // \TODO this is common
  // Get the library name and path
  var baseName = basenameWithoutExtension(library.uri);
  var uri = join('${baseName}_mapper.dart', base: sourcePath);
  var name = libraryName(packageName, uri);

  var generatedLibrary = new LibraryMetadata(
      name,
      uri,
      imported: imported,
      classes: mappers
  );

  // Note that the library is loaded
  //
  // The name of the library being converted is used as that is already known
  loaded[loadingName] = generatedLibrary;

  return generatedLibrary;
}
