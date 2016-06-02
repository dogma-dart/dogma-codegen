// Copyright (c) 2016, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:async';

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';
import 'package:meta/meta.dart';

import 'library_header_generation_step.dart';
import 'metadata_step.dart';
import 'source_generation_step.dart';
import 'view_generation_step.dart';
import 'view_step.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

abstract class SourceBuilder extends Builder
                                with LibraryHeaderGenerationStep
                          implements MetadataStep,
                                     SourceGenerationStep,
                                     ViewGenerationStep,
                                     ViewStep {
  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// The name of the package to output into.
  final String package;
  /// The output directory.
  final String libraryOutput;
  /// The [formatter] for the generated source code.
  final DartFormatter formatter;
  @override
  final bool outputLibraryName = false;
  @override
  final String copyright = '';

  //---------------------------------------------------------------------
  // Constructor
  //---------------------------------------------------------------------

  SourceBuilder(String package,
                this.libraryOutput,
                DartFormatter formatter)
      : package = package
      , formatter = formatter ?? new DartFormatter();

  //---------------------------------------------------------------------
  // Builder
  //---------------------------------------------------------------------

  @override
  Future build(BuildStep step) async {
    // Get the metadata
    var inputMetadata = await metadata(step);

    // Create the view over the metadata for processing
    var inputMetadataView = view(inputMetadata);

    // Build out the view for the generated code
    var generatedMetadataView = viewGeneration(inputMetadataView);

    // Create the header
    var buffer = new StringBuffer();
    generateHeader(generatedMetadataView.metadata, buffer);

    // Create the source code
    var generatedSourceCode = sourceCode(generatedMetadataView);
    buffer.writeln(generatedSourceCode);

    // See if anything should be outputted
    if (generatedSourceCode.isNotEmpty) {
      // Format the source code
      //
      // The uri parameter is required or else it will throw on Windows
      var formattedSourceCode = formatter.format(
          buffer.toString(),
          uri: new Uri()
      );

      // Output the asset
      var outputAsset = new Asset(outputAssetId(step.input.id), formattedSourceCode);

      step.writeAsString(outputAsset);
    }
  }

  @override
  List<AssetId> declareOutputs(AssetId inputId) => [outputAssetId(inputId)];

  AssetId outputAssetId(AssetId inputId) {
    // \TODO Move into path package
    var path = inputId.path;
    var split = path.lastIndexOf('/');
    var original = path.substring(split + 1);

    return new AssetId(package, '$libraryOutput/${filename(original)}');
  }

  @protected
  String filename(String original) => original;
}
