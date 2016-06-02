// Copyright (c) 2016, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_source_analyzer/metadata.dart';

import '../../view.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// A step in the build process that generates source code for a library.
abstract class SourceGenerationStep {
  /// Generates code from the library [source].
  String sourceCode(MetadataView<LibraryMetadata> source);
}
