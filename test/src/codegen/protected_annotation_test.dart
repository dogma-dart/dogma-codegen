// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:meta/meta.dart';
import 'package:test/test.dart';

import 'package:dogma_codegen/codegen.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Test entry point.
void main() {
  test('No generation', () {
    var buffer = new StringBuffer();
    generateProtectedAnnotation(1, buffer);
    expect(buffer, isEmpty);
  });
  test('Generation', () {
    var buffer = new StringBuffer();
    generateProtectedAnnotation(protected, buffer);
    expect(buffer.toString(), equalsIgnoringWhitespace('@protected'));
  });
}
