// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains tests for the [TypeMetadata] class.
library dogma_codegen.test.src.metadata.type_metadata_test;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';
import 'package:test/test.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// The maximum depth of a List or Map to create.
const int _maxDepth = 10;

/// Create a bool type.
TypeMetadata _boolType() => new TypeMetadata('bool');
/// Create an integer type.
TypeMetadata _intType() => new TypeMetadata('int');
/// Create a double type.
TypeMetadata _doubleType() => new TypeMetadata('double');
/// Create a number type.
TypeMetadata _numType() => new TypeMetadata('num');
/// Create a string type.
TypeMetadata _stringType() => new TypeMetadata('String');
/// Creates a user type.
TypeMetadata _userType() => new TypeMetadata('Foo');
/// Create a List type.
TypeMetadata _listType(TypeMetadata type, [int depth = 1]) {
  var root = new TypeMetadata('List', arguments: [type]);

  for (var i = 1; i < depth; ++i) {
    root = new TypeMetadata('List', arguments: [root]);
  }

  return root;
}
/// Create a Map type.
TypeMetadata _mapType(TypeMetadata key, TypeMetadata value, [int depth = 1]) {
  var root = new TypeMetadata('Map', arguments: [key, value]);

  for (var i = 1; i < depth; ++i) {
    root = new TypeMetadata('Map', arguments: [key, root]);
  }

  return root;
}

/// Test entry point.
void main() {
  test('bool type', () {
    var type = _boolType();

    expect(type.isInt, false);
    expect(type.isDouble, false);
    expect(type.isNum, false);
    expect(type.isBool, true);
    expect(type.isString, false);
    expect(type.isList, false);
    expect(type.isMap, false);
    expect(type.isBuiltin, true);
  });

  test('int type', () {
    var type = _intType();

    expect(type.isInt, true);
    expect(type.isDouble, false);
    expect(type.isNum, true);
    expect(type.isBool, false);
    expect(type.isString, false);
    expect(type.isList, false);
    expect(type.isMap, false);
    expect(type.isBuiltin, true);
  });

  test('double type', () {
    var type = _doubleType();

    expect(type.isInt, false);
    expect(type.isDouble, true);
    expect(type.isNum, true);
    expect(type.isBool, false);
    expect(type.isString, false);
    expect(type.isList, false);
    expect(type.isMap, false);
    expect(type.isBuiltin, true);
  });

  test('num type', () {
    var type = _numType();

    expect(type.isInt, false);
    expect(type.isDouble, false);
    expect(type.isNum, true);
    expect(type.isBool, false);
    expect(type.isString, false);
    expect(type.isList, false);
    expect(type.isMap, false);
    expect(type.isBuiltin, true);
  });

  test('String type', () {
    var type = _stringType();

    expect(type.isInt, false);
    expect(type.isDouble, false);
    expect(type.isNum, false);
    expect(type.isBool, false);
    expect(type.isString, true);
    expect(type.isList, false);
    expect(type.isMap, false);
    expect(type.isBuiltin, true);
  });

  test('User defined type', () {
    var type = _userType();

    expect(type.isInt, false);
    expect(type.isDouble, false);
    expect(type.isNum, false);
    expect(type.isBool, false);
    expect(type.isString, false);
    expect(type.isList, false);
    expect(type.isMap, false);
    expect(type.isBuiltin, false);
  });

  test('List type', () {
    var expectListType = (type, builtin) {
      expect(type.isInt, false);
      expect(type.isDouble, false);
      expect(type.isNum, false);
      expect(type.isBool, false);
      expect(type.isString, false);
      expect(type.isList, true);
      expect(type.isMap, false);
      expect(type.isBuiltin, builtin);
    };

    var checkListWithType = (type, maxDepth, builtin) {
      for (var i = 1; i < maxDepth; ++i) {
        expectListType(_listType(type, i), builtin);
      }
    };

    checkListWithType(_boolType(), _maxDepth, true);
    checkListWithType(_intType(), _maxDepth, true);
    checkListWithType(_doubleType(), _maxDepth, true);
    checkListWithType(_numType(), _maxDepth, true);
    checkListWithType(_stringType(), _maxDepth, true);
    checkListWithType(_userType(), _maxDepth, false);
  });

  test('Map type', () {
    var expectMapType = (type, builtin) {
      expect(type.isInt, false);
      expect(type.isDouble, false);
      expect(type.isNum, false);
      expect(type.isBool, false);
      expect(type.isString, false);
      expect(type.isList, false);
      expect(type.isMap, true);
      expect(type.isBuiltin, builtin);
    };

    var checkMapWithType = (type, maxDepth, builtin) {
      for (var i = 1; i < maxDepth; ++i) {
        expectMapType(_mapType(_stringType(), type, i), builtin);
      }
    };

    checkMapWithType(_boolType(), _maxDepth, true);
    checkMapWithType(_intType(), _maxDepth, true);
    checkMapWithType(_doubleType(), _maxDepth, true);
    checkMapWithType(_numType(), _maxDepth, true);
    checkMapWithType(_stringType(), _maxDepth, true);
    checkMapWithType(_userType(), _maxDepth, false);
  });
}
