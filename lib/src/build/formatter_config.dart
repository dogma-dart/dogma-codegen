// Copyright (c) 2016, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dart_style/dart_style.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Configuration for the Dart formatter.
class FormatterConfig {
  /// The line ending to use for new lines within the output.
  String lineEnding;
  /// The maximum width, in characters, of a line of dart code.
  int pageWidth;
  /// The levels of indentation that will be prefixed before each resulting
  /// line of output.
  int indent;
}

/// Creates the Dart formatter from the [config].
DartFormatter formatterFromConfig(FormatterConfig config) =>
    new DartFormatter(
        lineEnding: config.lineEnding,
        pageWidth: config.pageWidth,
        indent: config.indent
    );
