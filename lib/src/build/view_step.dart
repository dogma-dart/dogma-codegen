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

/// A step in the build process that takes the inputted metadata and provides
/// a view over the data.
///
/// In the SourceBuilder the results of the [ViewStep] are passed on to the
/// ViewGenerationStep.
abstract class ViewStep {
  /// Generates a [MetadataView] over the given [metadata].
  MetadataView<LibraryMetadata> view(LibraryMetadata metadata);
}
