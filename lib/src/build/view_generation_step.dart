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

/// A step in the build process that generates the metadata view to be
/// outputted by the library.
///
/// The output library is generated at this point in time using the source
/// library.
///
/// In the SourceBuilder the results of the [ViewGenerationStep] are passed on
/// to the SourceGenerationStep.
abstract class ViewGenerationStep {
  /// Generates a [MetadataView] over the [source] library.
  MetadataView<LibraryMetadata> viewGeneration(MetadataView<LibraryMetadata> source);
}
