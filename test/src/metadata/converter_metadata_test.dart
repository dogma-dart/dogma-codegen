// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.test.src.metadata.converter_metadata_test;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';
import 'package:test/test.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// The dummy type name.
const String _typeName = 'foo';
/// The dummy metadata name.
const String _metadataName = 'test';

/// Test entry point.
void main() {
  test('Properties', () {
    var type = new TypeMetadata(_typeName);

    var decoder = new ConverterMetadata(_metadataName, type, true);
    expect(decoder.isEncoder, false);

    var encoder = new ConverterMetadata(_metadataName, type, false);
    expect(encoder.isEncoder, true);
  });
}
