// Copyright (c) 2016, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_source_analyzer/metadata.dart';

import '../../view.dart';
import 'view_generation_step.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// An implementation of [ViewGenerationStep] that just returns the results of
/// the previous step.
///
/// This is useful in cases where there is no additional processing to achieve
/// the view required for codegen.
class SkipViewGenerationStep implements ViewGenerationStep {
  @override
  MetadataView<LibraryMetadata> viewGeneration(MetadataView<LibraryMetadata> source) =>
      source;
}
