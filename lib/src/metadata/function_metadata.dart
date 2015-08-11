// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [FunctionMetadata] class.
library dogma_codegen.src.metadata.function_metadata;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'metadata.dart';
import 'type_metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Contains metadata for a function that can be used for serialization.
///
/// The metadata is only for functions that take a single output and return a
/// single output. If the function should be used for all types then
/// [defaultConverter] will be true.
class FunctionMetadata extends Metadata {
  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// The input type for the function.
  final TypeMetadata input;
  /// The output type for the function.
  final TypeMetadata output;
  /// Whether function handles decoding.
  final bool decoder;

  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Creates an instance of [FunctionMetadata] with the given name and [input] and [output] types.
  ///
  /// If the function should be used by default for conversion then [decoder]
  /// should be specified otherwise it should remain null. If true then all
  /// types of [output] will use this function for decoding. If false then all
  /// types of [input] will use this function for encoding. However this will
  /// not be the case if a field is explicitly annotated with a different
  /// function.
  FunctionMetadata(String name, this.input, this.output, {this.decoder})
      : super(name);

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// Whether this function should used by default for construction.
  bool get defaultConverter => decoder != null;
}
