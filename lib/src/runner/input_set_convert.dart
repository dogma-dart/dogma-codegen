// Copyright (c) 2016, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:convert';

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:build/build.dart';
import 'package:dogma_convert/convert.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Decoder for a [InputSet].
class InputSetDecoder extends Converter<Map, InputSet>
                   implements ModelDecoder<InputSet> {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The key for the input package name.
  static const String inputPackageKey = 'input_package';
  /// The key for the set of input values.
  static const String inputSetKey = 'input_set';

  //---------------------------------------------------------------------
  // Constructor
  //---------------------------------------------------------------------

  /// Creates an instance of [InputSetDecoder].
  const InputSetDecoder();

  //---------------------------------------------------------------------
  // ModelDecoder
  //---------------------------------------------------------------------

  @override
  InputSet create() => throw new UnimplementedError('No default constructor on InputSet');

  @override
  InputSet convert(Map input, [InputSet model]) {
    var package = input[inputPackageKey];
    var inputs = input[inputSetKey] as List<String>;

    return new InputSet(package, inputs);
  }
}
