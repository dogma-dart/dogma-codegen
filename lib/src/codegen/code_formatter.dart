// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.src.codegen.code_formatter;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dart_style/dart_style.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// The code formatter.
///
/// Used to clean up the Dart code according to the style guide.
final _formatter = new DartFormatter();

/// Formats the generated code.
String formatCode(StringBuffer buffer) => _formatter.format(buffer.toString());
