// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:test/test.dart';

import 'package:dogma_codegen/codegen.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Test entry point.
void main() {
  test('No generation', () {
    var buffer = new StringBuffer();
    generateOverrideAnnotation(1, buffer);
    expect(buffer, isEmpty);
  });
  test('Generation', () {
    var buffer = new StringBuffer();
    generateOverrideAnnotation(override, buffer);
    expect(buffer.toString(), equalsIgnoringWhitespace('@override'));
  });
}
