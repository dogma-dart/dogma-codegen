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

import 'metadata_step.dart';
import 'source_generation_step.dart';
import 'view_generation_step.dart';
import 'view_step.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

abstract class SourceBuilder extends Builder
                          implements MetadataStep,
                                     SourceGenerationStep,
                                     ViewGenerationStep,
                                     ViewStep {
  @override
  Future build(BuildStep step) async {
    var inputMetadata = await metadata(step);

    if (inputMetadata != null) {
      print(inputMetadata.uri.toString());

      for (var clazz in inputMetadata.classes) {
        print(clazz.name);
      }

      for (var function in inputMetadata.functions) {
        print(function.name);
      }

      for (var field in inputMetadata.fields) {
        print(field.name);
      }

      print('');
    }

    var inputMetadataView = view(inputMetadata);
    var generatedMetadataView = viewGeneration(inputMetadataView);
    var generatedSourceCode = sourceCode(generatedMetadataView);

    print(generatedSourceCode);
  }

  @override
  List<AssetId> declareOutputs(AssetId inputId) => [inputId.addExtension('.copy')];
}
