// Copyright (c) 2016, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:io';

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dart_style/dart_style.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Configuration for the Dart formatter.
class FormatterConfig {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The default value for [lineEnding].
  static final String lineEndingDefault = Platform.isWindows ? '\n' : '\r\n';
  /// The default value for [pageWidth].
  static const int pageWidthDefault = 80;
  /// The default value for [indent].
  static const int indentDefault = 0;

  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// The line ending to use for new lines within the output.
  String lineEnding = lineEndingDefault;
  /// The maximum width, in characters, of a line of dart code.
  int pageWidth = pageWidthDefault;
  /// The levels of indentation that will be prefixed before each resulting
  /// line of output.
  int indent = indentDefault;
}

/// Creates the Dart formatter from the [config].
DartFormatter formatterFromConfig(FormatterConfig config) =>
    new DartFormatter(
        lineEnding: config.lineEnding,
        pageWidth: config.pageWidth,
        indent: config.indent
    );
