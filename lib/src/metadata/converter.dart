// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [Converter] interface.
library dogma_codegen.src.metadata.converter;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'type_metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Metadata that handles conversions.
abstract class Converter {
  /// Whether the converter handles encoding.
  bool get isEncoder;
  /// Whether the converter handles decoding.
  bool get isDecoder;
  /// The type of model the converter accepts.
  TypeMetadata get modelType;
}
