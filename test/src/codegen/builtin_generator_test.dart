// Copyright (c) 2015-2016 the Dogma Project Authors.
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

/// The number of values to use.
const int _length = 100;
/// A list of integers.
final List<int> _intList = [0, 1, 2, 3];
/// Expected value of the int list.
final String _expectedIntList = '[0,1,2,3]';
/// A list of strings.
final List<String> _stringList = ['foo', 'bar', 'fizz', 'buzz'];
/// Expected value of the string list.
final String _expectedStringList = '[\'foo\',\'bar\',\'fizz\',\'buzz\']';
/// A map.
final Map _map = {'ints': _intList, 'strings': _stringList};
/// Expected value of the map.
final String _expectedMap = '{\'ints\':$_expectedIntList,\'strings\':$_expectedStringList}';

/// A test enum.
enum TestEnum {
  foo, bar, fizz, buzz
}

/// Test entry point.
void main() {
  test('Numbers', () {
    for (var i = -_length; i < _length; ++i) {
      expect(generateBuiltin(i), i.toString());

      var d = i * 1.0;
      expect(generateBuiltin(d), d.toString());

      var f = i / _length;
      expect(generateBuiltin(f), f.toString());
    }
  });
  test('Strings', () {
    var s = 'foo';
    var expected = '\'$s\'';

    expect(generateBuiltin(s), expected);
    expect(generateString(s), expected);
  });
  test('Lists', () {
    expect(generateBuiltin(_intList), _expectedIntList);
    expect(generateList(_intList, false, false), _expectedIntList);

    expect(generateBuiltin(_stringList), _expectedStringList);
    expect(generateList(_stringList, false, false), _expectedStringList);
  });
  test('Maps', () {
    expect(generateBuiltin(_map), _expectedMap);
    expect(generateMap(_map, false, false), _expectedMap);
  });
  test('Enum', () {
    expect(generateBuiltin(TestEnum.bar), TestEnum.bar.toString());
  });
  test('Line break', () {
    var expected;
    expected = '[\n${_intList.join(',\n')}\n]';

    expect(generateBuiltin(_intList, lineBreak: true), expected);
    expect(generateList(_intList, true, false), expected);

    var map = {'a':0,'b':1};
    expected = '{\n\'a\':0,\n\'b\':1\n}';

    expect(generateBuiltin(map, lineBreak: true), expected);
    expect(generateMap(map, true, false), expected);
  });
}
