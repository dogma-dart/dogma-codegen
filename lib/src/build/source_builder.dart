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
    var contents = step.input.stringContents;

    // Determine if the output should be created
    var outputAssetId = _processedAssetId(
        step.input.id,
        package,
        libraryOutput
    );

    var inputMetadata = await metadata(step);
    var inputMetadataView = view(inputMetadata);
    var generatedMetadataView = viewGeneration(inputMetadataView);

    var buffer = new StringBuffer();
    generateHeader(generatedMetadataView.metadata, buffer);

    var generatedSourceCode = sourceCode(generatedMetadataView);
    buffer.writeln(generatedSourceCode);

    if (generatedSourceCode.isNotEmpty) {
      var input = step.input;
      var formattedSourceCode = formatter.format(buffer.toString(), uri: new Uri());
      //var formattedSourceCode = buffer.toString(); //formatter.formatStatement(buffer.toString());

      var outputAssetId = _processedAssetId(input.id, package, libraryOutput);
      var outputAsset = new Asset(outputAssetId, formattedSourceCode);

      await step.writeAsString(outputAsset);
    }
  }

  @override
  List<AssetId> declareOutputs(AssetId inputId) =>
      [_processedAssetId(inputId, package, libraryOutput)];

  static AssetId _processedAssetId(AssetId inputId,
                                   String package,
                                   String outputDirectory) {
    // \TODO Move into path package
    var path = inputId.path;
    var split = path.lastIndexOf('/');
    var filename = path.substring(split + 1);

    return new AssetId(package, '$outputDirectory/$filename');
  }
}
