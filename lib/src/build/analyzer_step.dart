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
import 'package:dogma_source_analyzer/analyzer.dart';
import 'package:dogma_source_analyzer/metadata.dart';

import 'metadata_step.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// An implementation of [MetadataStep] which uses the analyzer to create the
/// metadata.
class AnalyzerMetadataStep implements MetadataStep {
  @override
  Future<LibraryMetadata> metadata(BuildStep buildStep) async {
    var input = buildStep.input;
    var inputId = input.id;
    var resolver = await buildStep.resolve(inputId);
    var library = resolver.getLibrary(inputId);

    return libraryMetadataFromElement(library);
  }
}
