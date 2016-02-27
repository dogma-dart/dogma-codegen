// Copyright (c) 2016, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_source_analyzer/metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Provides a view over [Metadata].
///
/// This view allows wrapping of metadata into a more specific interface.
abstract class MetadataView<T extends Metadata> {
  /// The metadata being wrapped.
  final T metadata;

  /// Creates an instance of [MetadataView] over the given [metadata].
  MetadataView(this.metadata);
}
