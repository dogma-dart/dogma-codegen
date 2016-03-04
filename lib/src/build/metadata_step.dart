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
import 'package:dogma_source_analyzer/metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// A step in the build process that gets the metadata for a library.
abstract class MetadataStep {
  Future<LibraryMetadata> metadata(BuildStep buildStep);
}
