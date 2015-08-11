// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [ConverterMetadata] class.
library dogma_codegen.src.metadata.converter_metadata;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'metadata.dart';
import 'type_metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Contains metadata for a converter.
class ConverterMetadata extends Metadata {
  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// The type that can be converted.
  final TypeMetadata type;
  /// Whether the converter handles decoding.
  final bool decoder;

  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Creates an instance of [ConverterMetadata] for the given [type].
  ///
  /// Whehter or not the coverter will handle decoding is specified in
  /// [decoder].
  ConverterMetadata(String name, this.type, this.decoder)
      : super(name);

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// Whether the converter handles encoding.
  bool get encoder => !decoder;
}
