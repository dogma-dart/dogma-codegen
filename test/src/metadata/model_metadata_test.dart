// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains tests for the [ModelMetadata] class.
library dogma_codegen.test.src.metadata.model_metadata_test;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';
import 'package:test/test.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// The dummy metadata name
const String _metadataName = 'test';

/// DateTime type.
TypeMetadata _dateTime() => new TypeMetadata('DateTime');
/// NoConverter type.
TypeMetadata _noConvert() => new TypeMetadata('NoConvert');
/// DecodeOnly type.
TypeMetadata _decodeOnly() => new TypeMetadata('DecodeOnly');
/// EncodeOnly type.
TypeMetadata _encodeOnly() => new TypeMetadata('EncodeOnly');
/// Nested list type.
TypeMetadata _nestedList() => new TypeMetadata('NestedList');
/// Nested map type.
TypeMetadata _nestedMap() => new TypeMetadata('NestedMap');

/// Test entry point.
void main() {
  var fields = [
      new FieldMetadata('n', new TypeMetadata('num'), true, true),
      new FieldMetadata('d0', _dateTime(), true, true),
      new FieldMetadata('d1', _dateTime(), true, true),
      new FieldMetadata('no', _noConvert(), false, false),
      new FieldMetadata('decodeOnly', _decodeOnly(), true, false),
      new FieldMetadata('encodeOnly', _encodeOnly(), false, true),
      new FieldMetadata('l', new TypeMetadata('List', arguments: [_nestedList()]), true, true),
      new FieldMetadata('n', new TypeMetadata('Map', arguments: [new TypeMetadata('String'), _nestedMap()]), true, true)
  ];
  var metadata = new ModelMetadata('test', fields);

  test('Search for model dependencies', () {
    var dependencies = modelDependencies(metadata).toList();

    expect(dependencies.length, 6);
    expect(dependencies.contains(_dateTime()), true);
    expect(dependencies.contains(_noConvert()), true);
    expect(dependencies.contains(_decodeOnly()), true);
    expect(dependencies.contains(_encodeOnly()), true);
    expect(dependencies.contains(_nestedList()), true);
    expect(dependencies.contains(_nestedMap()), true);
  });

  test('Serach for model converter dependencies', () {
    var dependencies = modelConverterDependencies(metadata).toList();

    expect(dependencies.length, 5);
    expect(dependencies.contains(_dateTime()), true);
    expect(dependencies.contains(_noConvert()), false);
    expect(dependencies.contains(_decodeOnly()), true);
    expect(dependencies.contains(_encodeOnly()), true);
    expect(dependencies.contains(_nestedList()), true);
    expect(dependencies.contains(_nestedMap()), true);
  });

  test('Search for model decoder dependencies', () {
    var dependencies = modelDecoderDependencies(metadata).toList();

    expect(dependencies.length, 4);
    expect(dependencies.contains(_dateTime()), true);
    expect(dependencies.contains(_noConvert()), false);
    expect(dependencies.contains(_decodeOnly()), true);
    expect(dependencies.contains(_encodeOnly()), false);
    expect(dependencies.contains(_nestedList()), true);
    expect(dependencies.contains(_nestedMap()), true);
  });

  test('Search for model encoder dependencies', () {
    var dependencies = modelEncoderDependencies(metadata).toList();

    expect(dependencies.length, 4);
    expect(dependencies.contains(_dateTime()), true);
    expect(dependencies.contains(_noConvert()), false);
    expect(dependencies.contains(_decodeOnly()), false);
    expect(dependencies.contains(_encodeOnly()), true);
    expect(dependencies.contains(_nestedList()), true);
    expect(dependencies.contains(_nestedMap()), true);
  });
}
