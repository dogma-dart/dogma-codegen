// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.test.src.codegen.serialize_annotation_generator_test;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/src/codegen/serialize_annotation_generator.dart';
import 'package:dogma_convert/serialize.dart';
import 'package:test/test.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

const String _serializeField = '@Serialize.field';
const String _name = 'foo';
const String _decodeFunction = 'decodeFoo';
const String _encodeFunction = 'encodeFoo';

String _annotation(String name,
                  {bool decode: true,
                   bool encode: true,
                   bool optional: false,
                   dynamic defaultsTo})
{
  var annotation = new Serialize.field(
      name,
      decode: decode,
      encode: encode,
      optional: optional,
      defaultsTo: defaultsTo
  );

  var buffer = new StringBuffer();
  generateFieldAnnotation(annotation, buffer);

  return buffer.toString().trimRight();
}

/// Test entry point.
void main() {
  test('Only name', () {
    var annotation = _annotation(_name);
    expect(annotation, '$_serializeField(\'$_name\')');
  });
  test('Explicit decode', () {
    var annotation = _annotation(_name, decode: false);
    expect(annotation, '$_serializeField(\'$_name\',decode: false)');
  });
  test('Explicit encode', () {
    var annotation = _annotation(_name, encode: false);
    expect(annotation, '$_serializeField(\'$_name\',encode: false)');
  });
  test('Explicit optional', () {
    var annotation = _annotation(_name, optional: true);
    expect(annotation, '$_serializeField(\'$_name\',optional: true)');
  });
  test('Explicit defaultsTo', () {
    var annotation;
    var defaultsTo;

    defaultsTo = 0;
    annotation = _annotation(_name, defaultsTo: defaultsTo);
    expect(annotation, '$_serializeField(\'$_name\',defaultsTo: $defaultsTo)');

    defaultsTo = 'bar';
    annotation = _annotation(_name, defaultsTo: defaultsTo);
    expect(annotation, '$_serializeField(\'$_name\',defaultsTo: \'$defaultsTo\')');

    defaultsTo = [];
    annotation = _annotation(_name, defaultsTo: defaultsTo);
    expect(annotation, '$_serializeField(\'$_name\',defaultsTo: const[])');

    defaultsTo = {};
    annotation = _annotation(_name, defaultsTo: defaultsTo);
    expect(annotation, '$_serializeField(\'$_name\',defaultsTo: const{})');
  });
  test('Function', () {
    var serialize = new Serialize.function(
        _name,
        decode: _decodeFunction,
        encode: _encodeFunction
    );

    var buffer = new StringBuffer();
    generateFieldAnnotation(serialize, buffer);

    var annotation = buffer.toString().trimRight();
    expect(annotation, '@Serialize.function(\'$_name\',decode: \'$_decodeFunction\',encode: \'$_encodeFunction\')');
  });
}
