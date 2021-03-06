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

import 'package:dogma_convert/convert.dart';

import '../../build.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Decoder for a [FormatterConfig].
class FormatterConfigDecoder extends Converter<Map, FormatterConfig>
                          implements ModelDecoder<FormatterConfig> {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The key for the line ending value.
  static const String lineEndingKey = 'line_ending';
  /// The key for the page width value.
  static const String pageWidthKey = 'page_width';
  /// The key for the indent value.
  static const String indentKey = 'indent';

  //---------------------------------------------------------------------
  // Constructor
  //---------------------------------------------------------------------

  /// Creates an instance of [FormatterConfigDecoder].
  const FormatterConfigDecoder();

  //---------------------------------------------------------------------
  // ModelDecoder
  //---------------------------------------------------------------------

  @override
  FormatterConfig create() => new FormatterConfig();

  @override
  FormatterConfig convert(Map input, [FormatterConfig model]) {
    model ??= create();

    model.lineEnding = input[lineEndingKey] ?? FormatterConfig.lineEndingDefault;
    model.pageWidth = input[pageWidthKey] ?? FormatterConfig.pageWidthDefault;
    model.indent = input[indentKey] ?? FormatterConfig.indentDefault;

    return model;
  }
}
