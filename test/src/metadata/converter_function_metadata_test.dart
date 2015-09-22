// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains tests for the [FunctionMetadata] class.
library dogma_codegen.test.src.metadata.function_metadata_test;

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

    var function = new ConverterFunctionMetadata(_metadataName, type, type);
    expect(function.isDefaultConverter, false);

    var encoder = new ConverterFunctionMetadata(_metadataName, type, type, decoder: true);
    expect(encoder.isDefaultConverter, true);

    var decoder = new ConverterFunctionMetadata(_metadataName, type, type, decoder: false);
    expect(decoder.isDefaultConverter, true);
});
}
