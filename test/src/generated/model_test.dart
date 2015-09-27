// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains tests for checking validity of generated models.
library dogma_codegen.test.src.generated.model_test;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:test/test.dart';

import '../../libs/models.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Test entry point.
void main() {
  test('ColorImplicit', () {
    expect(ColorImplicit.values.length, 3);
    expect(ColorImplicit.red.index, 0);
    expect(ColorImplicit.green.index, 1);
    expect(ColorImplicit.blue.index, 2);
  });
}
