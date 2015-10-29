// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.test.src.codegen.argument_buffer_test;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/src/codegen/argument_buffer.dart';
import 'package:test/test.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// The number of values to write.
const int _length = 100;

/// Tests the writing of values to [buffer].
void _testWrite(ArgumentBuffer buffer) {
  var values = <String>[];

  for (var i = 0; i < _length; ++i) {
    values.add(i.toString());
  }

  buffer.writeAll(values);

  var result = buffer.toString();

  expect(result, values.join(buffer.separator));
}

/// Test entry point.
void main() {
  test('Single', () {
    var buffer = new ArgumentBuffer();
    var value = 'foo';

    buffer.write(value);

    expect(buffer.toString(), value);
  });
  test('Multiple', () {
    _testWrite(new ArgumentBuffer());
  });
  test('Line break', () {
    _testWrite(new ArgumentBuffer.lineBreak());
  });
}
