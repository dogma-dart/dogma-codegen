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

import 'asset.dart';
import 'asset_output.dart';
import 'builder_config.dart';
import 'configurable.dart';
import 'formatter_config.dart';
import 'library_header_generation_step.dart';
import 'metadata_step.dart';
import 'source_generation_step.dart';
import 'target_config.dart';
import 'view_generation_step.dart';
import 'view_step.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// The base class for a builder that generates source code.
///
/// The [SourceBuilder] class orchestrates the generation of code. It pipelines
/// the build into multiple steps.
///
/// 1. [MetadataStep]
/// 2. [ViewStep]
/// 3. [ViewGenerationStep].
/// 4. [SourceGenerationStep].
///
/// If any source code is generated it will output the file to the output
/// directory within the [config].
///
/// Typically an implementer just extends the [SourceBuilder] and provides
/// implementations of the steps being implemented.
abstract class SourceBuilder<T extends TargetConfig> extends Builder
                                                        with Configurable<T>,
                                                             AssetOutput<T>,
                                                             LibraryHeaderGenerationStep
                                                  implements MetadataStep,
                                                             SourceGenerationStep,
                                                             ViewGenerationStep,
                                                             ViewStep {
  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  @override
  final String package;
  @override
  final BuilderConfig<T> config;
  /// The [formatter] for the generated source code.
  final DartFormatter formatter;

  //---------------------------------------------------------------------
  // Constructor
  //---------------------------------------------------------------------

  /// Creates an instance of [SourceBuilder] with the given [config].
  SourceBuilder(BuilderConfig config)
      : package = currentPackageName
      , config = config
      , formatter = formatterFromConfig(config.formatterConfig);

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
}
