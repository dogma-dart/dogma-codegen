// Copyright (c) 2016, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:async';
import 'dart:io';

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:build/build.dart';
import 'package:dogma_source_analyzer/metadata.dart';
import 'package:dogma_source_analyzer/path.dart' as p;

import 'asset.dart';
import 'configurable.dart';
import 'library_header_generation_step.dart';
import 'root_library_builder_config.dart';
import 'target_config.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Builds the root library which exports the contents of a source directory.
class RootLibraryBuilder extends Builder
                            with LibraryHeaderGenerationStep,
                                 Configurable<TargetConfig> {
  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  @override
  final String package;
  @override
  RootLibraryBuilderConfig config;
  /// The asset identifier for the root library.
  final AssetId _rootLibrary;

  //---------------------------------------------------------------------
  // Constructor
  //---------------------------------------------------------------------

  /// Creates an instance of the [RootLibraryBuilder] with the given [config].
  RootLibraryBuilder(RootLibraryBuilderConfig config)
      : package = currentPackageName
      , config = config
      , _rootLibrary = rootAssetIdFromUri(p.join(config.libraryPath));

  //---------------------------------------------------------------------
  // Builder
  //---------------------------------------------------------------------

  @override
  Future<Null> build(BuildStep buildStep) async {
    // Get the logger
    var logger = buildStep.logger;

    // Create a list of exports
    var exports = <UriReferencedMetadata>[];

    // Iterate over the directory
    var directory = new Directory(p.join(config.sourceDirectory).toFilePath());

    await for (var value in directory.list(recursive: false, followLinks: false)) {
      if (value is File) {
        var libraryUri = new Uri.file(value.path);

        logger.info('Found library at ${libraryUri.toFilePath()}');

        var exported = new LibraryMetadata(libraryUri);

        exports.add(new UriReferencedMetadata.withLibrary(exported));
      }
    }

    // Create the library
    var library = new LibraryMetadata(p.join(_rootLibrary.path), exports: exports);

    // Write the header
    var buffer = new StringBuffer();

    generateHeader(library, buffer);

    // Create the asset
    var output = new Asset(_rootLibrary, buffer.toString());

    // Write the asset out
    buildStep.writeAsString(output);
  }

  @override
  List<AssetId> declareOutputs(AssetId inputId) => [ _rootLibrary ];
}
