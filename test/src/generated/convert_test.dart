// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains tests for checking validity of generated converters.
library dogma_codegen.test.src.generated.convert_test;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:test/test.dart';

import '../../libs/convert.dart';
import '../../libs/models.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Test entry point.
void main() {
  test('ColorImplicit convert', () {
    var red = 'red';
    var green = 'green';
    var blue = 'blue';

    expect(decodeColorImplicit(red), ColorImplicit.red);
    expect(decodeColorImplicit(green), ColorImplicit.green);
    expect(decodeColorImplicit(blue), ColorImplicit.blue);

    expect(decodeColorImplicit('x', ColorImplicit.red), ColorImplicit.red);
    expect(decodeColorImplicit('x', ColorImplicit.green), ColorImplicit.green);
    expect(decodeColorImplicit('x', ColorImplicit.blue), ColorImplicit.blue);

    expect(encodeColorImplicit(ColorImplicit.red), red);
    expect(encodeColorImplicit(ColorImplicit.green), green);
    expect(encodeColorImplicit(ColorImplicit.blue), blue);
  });
}
