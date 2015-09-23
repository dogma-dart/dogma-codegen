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

const String _decoderName = 'decoder';
const String _encoderName = 'encoder';
const String _parameterName = 'value';

final TypeMetadata _modelType = new TypeMetadata('Test');
final TypeMetadata _encodeType = new TypeMetadata('String');

ConverterFunctionMetadata _decoder(bool isDefault) {
  return new ConverterFunctionMetadata(
      _decoderName,
      _modelType,
      new ParameterMetadata(_parameterName, _encodeType),
      isDefaultConverter: isDefault
  );
}

ConverterFunctionMetadata _encoder(bool isDefault) {
  return new ConverterFunctionMetadata(
      _encoderName,
      _encodeType,
      new ParameterMetadata(_parameterName, _modelType),
      isDefaultConverter: isDefault
  );
}

void _expectDecoder(ConverterFunctionMetadata metadata, bool isDefault) {
  expect(metadata.name, _decoderName);
  expect(metadata.isDecoder, true);
  expect(metadata.isEncoder, false);
  expect(metadata.isDefaultConverter, isDefault);
  expect(metadata.isDefaultDecoder, isDefault);
  expect(metadata.isDefaultEncoder, false);
  expect(metadata.modelType, _modelType);
  expect(metadata.encodeType, _encodeType);
}

void _expectEncoder(ConverterFunctionMetadata metadata, bool isDefault) {
  expect(metadata.name, _encoderName);
  expect(metadata.isDecoder, false);
  expect(metadata.isEncoder, true);
  expect(metadata.isDefaultConverter, isDefault);
  expect(metadata.isDefaultDecoder, false);
  expect(metadata.isDefaultEncoder, isDefault);
  expect(metadata.modelType, _modelType);
  expect(metadata.encodeType, _encodeType);
}

/// Test entry point.
void main() {
  test('Properties', () {
    var decoder = _decoder(false);
    _expectDecoder(decoder, false);

    var defaultDecoder = _decoder(true);
    _expectDecoder(defaultDecoder, true);

    var encoder = _encoder(false);
    _expectEncoder(encoder, false);

    var defaultEncoder = _encoder(true);
    _expectEncoder(defaultEncoder, true);
  });
}
