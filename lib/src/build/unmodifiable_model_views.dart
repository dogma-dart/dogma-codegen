// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains functions to create unmodifiable views over models.
library dogma_codegen.src.build.unmodifiable_model_views;

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:async';

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:logging/logging.dart';

import '../../metadata.dart';
import '../../path.dart';

import 'libraries.dart';
import 'io.dart';
import 'search.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// The logger for the library.
final Logger _logger = new Logger('dogma_codegen.src.build.unmodifiable_model_views');

/// Builds the unmodifiable views library from the given [models] library.
///
/// The value of [models] is passed to [unmodifiableModelViewsLibrary] which
/// transforms the library into the equivalent unmodifiable version. The root
/// of the library is set to [libraryPath] while any exported libraries will
/// be generated into [sourcePath].
///
/// Additionally the [sourcePath] will be searched for any user defined
/// libraries which will be preferred over the generated equivalents.
///
/// The function will also write the resulting libraries to disk based on the
/// paths specified using the [writeUnmodifiableViews] function.
Future<Null> buildUnmodifiableViews(LibraryMetadata models,
                                    Uri libraryPath,
                                    Uri sourcePath) async {
  // Search for any user defined libraries
  await for (var library in findUserDefinedLibraries(sourcePath)) {
    _logger.info('Found user defined library at ${library.uri}');
  }

  // Create the equivalent library
  var views = unmodifiableModelViewsLibrary(models, libraryPath, sourcePath);

  // Write the library to disk.
  await writeUnmodifiableViews(views);
}

/// Writes the unmodifiable model [views] library to disk.
///
/// The value of [views] should be the root library which exports the others.
Future<Null> writeUnmodifiableViews(LibraryMetadata views) async {
  for (var export in views.exported) {
    _logger.info('Writing ${export.name} to disk at ${export.uri}');
    await writeUnmodifiableModelViewsLibrary(export);
  }

  _logger.info('Writing ${views.name} to disk at ${views.uri}');
  await writeRootLibrary(views);
}

/// Transforms the [models] library into the equivalent library containing
/// unmodifiable views.
///
/// The root of the library is set to [libraryPath] while any exported
/// libraries will be generated into [sourcePath].
LibraryMetadata unmodifiableModelViewsLibrary(LibraryMetadata models,
                                              Uri libraryPath,
                                              Uri sourcePath) {
  // \TODO FUNCTION FOR THIS???
  var packageName = models.name.split('.')[0];

  // Convert the modelLibrary into the equivalent using package notation.
  models = packageLibrary(models);

  var exported = <LibraryMetadata>[];

  for (var export in models.exported) {
    exported.add(_unmodifiableModelViewsLibrary(export, models, packageName, sourcePath));
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
                                               Uri sourcePath) {
  var imported = <LibraryMetadata>[modelLibrary];

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
      classes: library.classes
  );
}
