// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.test.src.metadata.enum_metadata_test;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';
import 'package:test/test.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// The dummy metadata name.
const String _metadataName = 'test';
/// The enumeration values.
final _values = <String>['a', 'b', 'c', 'd'];
/// The encoded enumeration values.
final _encoded = <String>['a_value', 'b_value', 'c_value', 'd_value'];

/// Checks the [metadata] values are equivalent to [values] and [encoded].
void _checkValues(EnumMetadata metadata, List<String> values, List<String> encoded) {
  var count = values.length;
  var mapping = metadata.serializeAnnotation.mapping;
  var mappingValues = mapping.values.toList();
  var mappingEncoded = mapping.keys.toList();

  for (var i = 0; i < count; ++i) {
    expect(mappingValues[i].name, values[i]);
    expect(mappingEncoded[i], encoded[i]);
  }
}

/// Test entry point.
void main() {
  test('Construction without explicit serialization', () {
    var metadata = new EnumMetadata(_metadataName, _values);

    _checkValues(metadata, _values, _values);
    expect(metadata.explicitSerialization, false);
  });

  test('Construction with explicit serialization', () {
    var metadata = new EnumMetadata('test', _values, encoded: _encoded);

    _checkValues(metadata, _values, _encoded);
    expect(metadata.explicitSerialization, true);
  });
}
