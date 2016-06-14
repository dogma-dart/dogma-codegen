// Copyright (c) 2016, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:convert';
import 'dart:io';

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_convert/convert.dart';

import '../../build.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Decoder for a [TargetConfig].
class TargetConfigDecoder extends Converter<Map, TargetConfig>
                       implements ModelDecoder<TargetConfig> {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The key for the exclude value.
  static const String excludeKey = 'exclude';

  //---------------------------------------------------------------------
  // Constructor
  //---------------------------------------------------------------------

  /// Creates an instance of [TargetConfigDecoder].
  const TargetConfigDecoder();

  //---------------------------------------------------------------------
  // ModelDecoder
  //---------------------------------------------------------------------

  @override
  TargetConfig create() => new TargetConfig();

  @override
  TargetConfig convert(Map input, [TargetConfig model]) {
    model ??= create();

    model.exclude = input[excludeKey] ?? false;

    return model;
  }
}
