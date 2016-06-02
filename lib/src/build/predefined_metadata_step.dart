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
import 'package:dogma_codegen/build.dart';
import 'package:dogma_source_analyzer/metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// An implementation of [MetadataStep] that just returns predefined library
/// metadata.
///
/// The [PredefinedMetadataStep] can be used to generate source code from
/// metadata created in code. It can also be used to test the output of a source
/// builder in an end to end manner. It will pass the metadata given along to
/// the next steps of the generation process.
abstract class PredefinedMetadataStep implements MetadataStep {
  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// The library containing the predefined metadata.
  LibraryMetadata get library;

  //---------------------------------------------------------------------
  // MetadataStep
  //---------------------------------------------------------------------

  @override
  Future<LibraryMetadata> metadata(BuildStep buildStep) async => library;
}
