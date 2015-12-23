// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [build] function which orchestrates the build process for a
/// library.
library dogma_codegen.build;

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:async';

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/analyzer.dart';
import 'package:dogma_codegen/path.dart';
import 'package:dogma_codegen/template.dart' as template;
import 'package:logging/logging.dart';

import 'src/build/build_system.dart';
import 'src/build/converters.dart';
import 'src/build/default_paths.dart';
import 'src/build/mappers.dart';
import 'src/build/logging.dart';
import 'src/build/unmodifiable_model_views.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// The logger for the library.
final Logger _logger = new Logger('dogma_codegen.build');

/// Builds the unmodifiable view library and convert library for the project.
///
/// This build function should be used when the models were defined without
/// the aid of any codegen.
///
/// To use in a library a build.dart file should be created in the package
/// root. This was the convention of the Dart Editor for codegen. If the editor
/// being used does not follow this convention then the
/// [build_system](https://pub.dartlang.org/packages/build_system) library can
/// be used to emulate this functionality.
///
/// An example build.dart using all the defaults follows.
///
///     import 'dart:async';
///     import 'package:dogma_codegen/build.dart';
///
///     Future<Null> main(List<String> args) async {
///       await build(args);
///     }
///
/// By convention the Dogma Codegen library uses the following directory
/// structure for libraries.
///
///     package_root
///       lib
///         src
///           models
///             foo.dart
///             bar.dart
///           convert
///             foo_convert.dart
///             bar_convert.dart
///           unmodifiable_model_view
///             unmodifiable_foo_view.dart
///             unmodifiable_bar_view.dart
///         models.dart
///         convert.dart
///         unmodifiable_model_view.dart
///
/// To get the best results from the codegen process the root [modelLibrary]
/// should just export all the libraries contained in [modelPath]. All the root
/// library locations, [modelLibrary], [unmodifiableLibrary], and
/// [convertLibrary], along with the output paths, [modelPath],
/// [unmodifiablePath], and [convertPath], can be explicitly set as well.
/// Deviating from the conventions should not break the codegen process, but
/// they should be followed for publicly available libraries to be consistent
/// with other clients using Dogma.
///
/// While [header] is optional it should be specified to provide any license
/// information for the generated libraries.
Future<Null> build(List<String> args,
                  {String modelLibrary: defaultModelLibrary,
                   String modelPath: defaultModelPath,
                   bool unmodifiable: true,
                   String unmodifiableLibrary: defaultUnmodifiableLibrary,
                   String unmodifiablePath: defaultUnmodifiablePath,
                   bool convert: true,
                   String convertLibrary: defaultConvertLibrary,
                   String convertPath: defaultConvertPath,
                   bool mapper: true,
                   String mapperLibrary: defaultMapperLibrary,
                   String mapperPath: defaultMapperPath,
                   String header: ''}) async {
  // Initialize logging
  initializeLogging();

  // See if a build should happen
  if (!await shouldBuild(args, [modelLibrary, modelPath, convertPath])) {
    _logger.info('Build is up to date.');
    return;
  }

  // Load the model library
  var context = analysisContext();
  var rootLibrary = libraryMetadata(modelLibrary, context);

  // Verify that the library was loaded
  if (rootLibrary == null) {
    _logger.severe('Model library could not be loaded!');
    return;
  }

  // Set the header
  template.header = header;

  // Build the unmodifiable model view library
  if (unmodifiable) {
    _logger.info('Building unmodifiable model view library');

    await buildUnmodifiableViews(
        rootLibrary,
        join(unmodifiableLibrary),
        join(unmodifiablePath)
    );
  }

  // Build the convert library
  if (convert) {
    _logger.info('Building convert library');

    await buildConverters(
        rootLibrary,
        join(convertLibrary),
        join(convertPath)
    );
  }

  // Build the mapper library
  if (mapper) {
    _logger.info('Building mapper library');

    await buildMappers(
        rootLibrary,
        join(mapperLibrary),
        join(mapperPath)
    );
  }
}
