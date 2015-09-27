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

    expect(decodeColorImplicit('x'), ColorImplicit.red);
    expect(decodeColorImplicit('x', ColorImplicit.red), ColorImplicit.red);
    expect(decodeColorImplicit('x', ColorImplicit.green), ColorImplicit.green);
    expect(decodeColorImplicit('x', ColorImplicit.blue), ColorImplicit.blue);

    expect(encodeColorImplicit(ColorImplicit.red), red);
    expect(encodeColorImplicit(ColorImplicit.green), green);
    expect(encodeColorImplicit(ColorImplicit.blue), blue);
  });
  test('ColorExplicit convert', () {
    var red = 0xff0000;
    var green = 0x00ff00;
    var blue = 0x0000ff;

    expect(decodeColorExplicit(red), ColorExplicit.red);
    expect(decodeColorExplicit(green), ColorExplicit.green);
    expect(decodeColorExplicit(blue), ColorExplicit.blue);

    expect(decodeColorExplicit(0), ColorExplicit.red);
    expect(decodeColorExplicit(0, ColorExplicit.red), ColorExplicit.red);
    expect(decodeColorExplicit(0, ColorExplicit.green), ColorExplicit.green);
    expect(decodeColorExplicit(0, ColorExplicit.blue), ColorExplicit.blue);

    expect(encodeColorExplicit(ColorExplicit.red), red);
    expect(encodeColorExplicit(ColorExplicit.green), green);
    expect(encodeColorExplicit(ColorExplicit.blue), blue);
  });
}
