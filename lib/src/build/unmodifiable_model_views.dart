// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.src.build.unmodifiable_model_views;

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:async';

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';
import 'package:dogma_codegen/io.dart';
import 'package:dogma_codegen/path.dart';

import 'libraries.dart';
import 'search.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

Future<Null> buildUnmodifiableViews(LibraryMetadata models,
                                               Uri libraryPath,
                                               Uri sourcePath) async
{
  await for (var library in findUserDefinedLibraries(sourcePath)) {
    print(library.uri);
  }

  for (var export in models.exported) {
    await writeUnmodifiableModelViewsLibrary(export);
  }

  await writeRootLibrary(models);
}

LibraryMetadata unmodifiableModelViewsLibrary(LibraryMetadata modelLibrary,
                                              Uri libraryPath,
                                              Uri sourcePath)
{
  // \TODO FUNCTION FOR THIS???
  var packageName = modelLibrary.name.split('.')[0];

  // Convert the modelLibrary into the equivalent using package notation.
  modelLibrary = packageLibrary(modelLibrary);

  var exported = new List<LibraryMetadata>();

  for (var export in modelLibrary.exported) {
    exported.add(_unmodifiableModelViewsLibrary(export, modelLibrary, packageName, sourcePath));
  }

  // Get the package name from the library
  var name = libraryName(packageName, libraryPath);

  return new LibraryMetadata(name, libraryPath, exported: exported);
}

/// Generates the unmodifiable version of the [library].
///
/// An unmodifiable version requires the original [modelLibrary] to get the
/// model definition. It also requires the [packageName] for generating the
/// library name. The [sourcePath] is the directory where the library will be
/// available from.
LibraryMetadata _unmodifiableModelViewsLibrary(LibraryMetadata library,
                                               LibraryMetadata modelLibrary,
                                               String packageName,
                                               Uri sourcePath)
{
  var imported = [modelLibrary] as List<LibraryMetadata>;

  // \TODO Should be adding library dependencies here

  // See if dart:collection is required
  var useCollection = false;

  for (var model in library.models) {
    if ((model.usesList) || (model.usesMap)) {
      useCollection = true;
      break;
    }
  }

  if (useCollection) {
    imported.add(dartCollection);
  }

  // Get the path
  var baseName = basenameWithoutExtension(library.uri);
  var uri = join('unmodifiable_${baseName}_view.dart', base: sourcePath);
  var name = libraryName(packageName, uri);

  return new LibraryMetadata(
      name,
      uri,
      imported: imported,
      models: library.models
  );
}
