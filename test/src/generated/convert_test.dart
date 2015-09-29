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
  test('ModelImplicit convert', () {
    var nKey = 'n';
    var iKey = 'i';
    var dKey = 'd';
    var bKey = 'b';
    var sKey = 's';
    var lKey = 'l';
    var mKey = 'm';

    var values = {
      nKey: 1.0,
      iKey: 2,
      dKey: 3.0,
      bKey: true,
      sKey: 'foo',
      lKey: [0, 1, 2, 3, 4],
      mKey: {
        'a': 0.0,
        'b': 1.0
      }
    };

    var decoder = new ModelImplicitDecoder();
    var decoded = decoder.convert(values);

    expect(decoded.n, values[nKey]);
    expect(decoded.i, values[iKey]);
    expect(decoded.d, values[dKey]);
    expect(decoded.b, values[bKey]);
    expect(decoded.s, values[sKey]);
    expect(decoded.l, values[lKey]);
    expect(decoded.m, values[mKey]);

    var encoder = new ModelImplicitEncoder();
    var encoded = encoder.convert(decoded);

    expect(encoded, values);
  });
  test('ModelExplicit convert', () {
    var nKey = 'n';
    var iKey = 'i';
    var dKey = 'd';
    var bKey = 'b';
    var sKey = 's';
    var lKey = 'l';
    var mKey = 'm';

    var values = {
      nKey: 1.0,
      iKey: 2,
      dKey: 3.0,
      bKey: true,
      sKey: 'foo',
      lKey: [0, 1, 2, 3, 4],
      mKey: {
        'a': 0.0,
        'b': 1.0
      }
    };

    var decoder = new ModelImplicitDecoder();
    var decoded = decoder.convert(values);

    expect(decoded.n, values[nKey]);
    expect(decoded.i, values[iKey]);
    expect(decoded.d, values[dKey]);
    expect(decoded.b, values[bKey]);
    expect(decoded.s, values[sKey]);
    expect(decoded.l, values[lKey]);
    expect(decoded.m, values[mKey]);

    var encoder = new ModelImplicitEncoder();
    var encoded = encoder.convert(decoded);

    expect(encoded, values);
  });
  test('ModelExplicit convert', () {
    var nKey = 'num';
    var iKey = 'int';
    var dKey = 'double';
    var bKey = 'bool';
    var sKey = 'string';
    var lKey = 'numList';
    var mKey = 'stringNumMap';

    var values = {
      nKey: 1.0,
      iKey: 2,
      dKey: 3.0,
      bKey: true,
      sKey: 'foo',
      lKey: [0, 1, 2, 3, 4],
      mKey: {
        'a': 0.0,
        'b': 1.0
      }
    };

    var decoder = new ModelExplicitDecoder();
    var decoded = decoder.convert(values);

    expect(decoded.n, values[nKey]);
    expect(decoded.i, values[iKey]);
    expect(decoded.d, values[dKey]);
    expect(decoded.b, values[bKey]);
    expect(decoded.s, values[sKey]);
    expect(decoded.l, values[lKey]);
    expect(decoded.m, values[mKey]);

    var encoder = new ModelExplicitEncoder();
    var encoded = encoder.convert(decoded);

    expect(encoded, values);
  });
  test('ModelExplicitConvert convert', () {
    var dIName = 'dI';
    var dSName = 'dS';
    var dLName = 'dL';
    var eIName = 'eI';
    var eSName = 'eS';
    var eLName = 'eL';

    var decodeValues = {
      dIName: 0,
      dSName: 'foo',
      dLName: [0, 1, 2, 3, 4]
    };
    var encodeValues = {
      eIName: 1,
      eSName: 'bar',
      eLName: [5, 6, 7, 8, 9]
    };

    var combined = new Map.from(decodeValues)..addAll(encodeValues);

    var decoder = new ModelExplicitConvertDecoder();
    var decoded = decoder.convert(combined);

    expect(decoded.dI, decodeValues[dIName]);
    expect(decoded.dS, decodeValues[dSName]);
    expect(decoded.dL, decodeValues[dLName]);
    expect(decoded.eI, null);
    expect(decoded.eS, null);
    expect(decoded.eL, null);

    decoded.eI = encodeValues[eIName];
    decoded.eS = encodeValues[eSName];
    decoded.eL = encodeValues[eLName];

    var encoder = new ModelExplicitConvertEncoder();
    var encoded = encoder.convert(decoded);

    expect(encoded.length, 3);
    expect(encoded, encodeValues);
  });
}
