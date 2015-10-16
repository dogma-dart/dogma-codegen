// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains tests for checking validity of generated models.
library dogma_codegen.test.src.generated.model_test;

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:mirrors';

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_convert/serialize.dart';
import 'package:test/test.dart';

import '../../libs/models.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

ClassMirror _getClass(Symbol library, Symbol clazz) {
  var libraryMirror = currentMirrorSystem().findLibrary(library);

  return libraryMirror.declarations[clazz];
}

/// Helper for comparing types.
///
/// There doesn't seem to be a way to instantiate generic Type's in a simple
/// way so [expected] can be [Type] or [String]. If the former then the Type is
/// compared directly. If its a string then the actual type is converted to
/// a string and compared against that.
void _expectType(Type actual, dynamic expected) {
  if (expected is Type) {
    expect(actual, expected);
  } else {
    expect(actual.toString(), expected);
  }
}

/// Test entry point.
void main() {
  test('ColorImplicit', () {
    expect(ColorImplicit.values.length, 3);
    expect(ColorImplicit.red.index, 0);
    expect(ColorImplicit.green.index, 1);
    expect(ColorImplicit.blue.index, 2);

    var clazz = _getClass(
        #dogma_codegen.test.libs.src.models.color_implicit,
        #ColorImplicit
    );

    // Shouldn't have any annotations
    expect(clazz.metadata.length, 0);
  });
  test('ColorExplicit', () {
    expect(ColorExplicit.values.length, 3);
    expect(ColorExplicit.red.index, 0);
    expect(ColorExplicit.green.index, 1);
    expect(ColorExplicit.blue.index, 2);

    var clazz = _getClass(
        #dogma_codegen.test.libs.src.models.color_explicit,
        #ColorExplicit
    );

    // Check for annotation
    var metadata = clazz.metadata;
    expect(metadata.length, 1);
    expect(metadata[0].reflectee is Serialize, true);

    // Check annotation values
    var serialize = metadata[0].reflectee as Serialize;
    var mapping = serialize.mapping;

    expect(mapping.isNotEmpty, true);
    expect(mapping.keys.length, ColorExplicit.values.length);
    expect(mapping[0xff0000], ColorExplicit.red);
    expect(mapping[0x00ff00], ColorExplicit.green);
    expect(mapping[0x0000ff], ColorExplicit.blue);
  });
  test('ModelImplicit', () {
    var clazz = _getClass(
        #dogma_codegen.test.libs.src.models.model_implicit,
        #ModelImplicit
    );

    var expectField = (Symbol name, dynamic type) {
      var field = clazz.declarations[name] as VariableMirror;
      _expectType(field.type.reflectedType, type);
      expect(field.metadata.length, 0);
    };

    expectField(#n, num);
    expectField(#i, int);
    expectField(#d, double);
    expectField(#b, bool);
    expectField(#s, String);
    expectField(#l, 'List<num>');
    expectField(#m, 'Map<String, num>');
  });
  test('ModelExplicit', () {
    var clazz = _getClass(
        #dogma_codegen.test.libs.src.models.model_explicit,
        #ModelExplicit
    );

    var expectField = (Symbol name, dynamic type, String serialized) {
      var field = clazz.declarations[name] as VariableMirror;
      _expectType(field.type.reflectedType, type);
      expect(field.metadata.length, 1);

      var annotation = field.metadata[0].reflectee as Serialize;
      expect(annotation.name, serialized);
      expect(annotation.encode, true);
      expect(annotation.decode, true);
    };

    expectField(#n, num, 'num');
    expectField(#i, int, 'int');
    expectField(#d, double, 'double');
    expectField(#b, bool, 'bool');
    expectField(#s, String, 'string');
    expectField(#l, 'List<num>', 'numList');
    expectField(#m, 'Map<String, num>', 'stringNumMap');
  });
  test('ModelExplicitConvert', () {
    var clazz = _getClass(
        #dogma_codegen.test.libs.src.models.model_explicit_convert,
        #ModelExplicitConvert
    );

    var expectField = (Symbol name, dynamic type, String serialize, bool decode) {
      var field = clazz.declarations[name] as VariableMirror;
      _expectType(field.type.reflectedType, type);
      expect(field.metadata.length, 1);

      var annotation = field.metadata[0].reflectee as Serialize;
      expect(annotation.name, serialize);
      expect(annotation.encode, !decode);
      expect(annotation.decode, decode);
    };

    expectField(#dI, int, 'dI', true);
    expectField(#dS, String, 'dS', true);
    expectField(#dL, 'List<num>', 'dL', true);
    expectField(#eI, int, 'eI', false);
    expectField(#eS, String, 'eS', false);
    expectField(#eL, 'List<num>', 'eL', false);
  });
  test('ModelOptional', () {
    var clazz = _getClass(
        #dogma_codegen.test.libs.src.models.model_optional,
        #ModelOptional
    );

    var expectField = (Symbol name, dynamic type, String serialized, dynamic defaultsTo) {
      var field = clazz.declarations[name] as VariableMirror;
      _expectType(field.type.reflectedType, type);
      expect(field.metadata.length, 1);

      var annotation = field.metadata[0].reflectee as Serialize;
      expect(annotation.name, serialized);
      expect(annotation.encode, true);
      expect(annotation.decode, true);
      expect(annotation.optional, true);
      expect(annotation.defaultsTo, defaultsTo);
    };

    expectField(#n, num, 'n', 1.0);
    expectField(#i, int, 'i', 2);
    expectField(#d, double, 'd', 3.0);
    expectField(#b, bool, 'b', true);
    expectField(#s, String, 's', 'foo');
    expectField(#l, 'List<num>', 'l', [0, 1, 2, 3, 4]);
    expectField(#m, 'Map<String, num>', 'm', {'a': 0.0, 'b': 1.0});
  });
  test('ModelFunction', () {
    var clazz = _getClass(
        #dogma_codegen.test.libs.src.models.model_function,
        #ModelFunction
    );

    var field;
    var annotation;

    field = clazz.declarations[#d] as VariableMirror;
    _expectType(field.type.reflectedType, Duration);

    annotation = field.metadata[0].reflectee as Serialize;
    expect(annotation.name, 'd');
    expect(annotation.decode, true);
    expect(annotation.decodeUsing, null);
    expect(annotation.encode, true);
    expect(annotation.encodeUsing, null);
    expect(annotation.optional, false);
    expect(annotation.defaultsTo, null);

    field = clazz.declarations[#od] as VariableMirror;
    _expectType(field.type.reflectedType, Duration);

    annotation = field.metadata[0].reflectee as Serialize;
    expect(annotation.name, 'od');
    expect(annotation.decode, true);
    expect(annotation.decodeUsing, 'decodeDurationInMinutes');
    expect(annotation.encode, true);
    expect(annotation.encodeUsing, 'encodeDurationInMinutes');
    expect(annotation.optional, false);
    expect(annotation.defaultsTo, null);
  });
}
