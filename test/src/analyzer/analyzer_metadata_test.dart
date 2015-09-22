// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.test.src.analyzer.analyzer_metadata_test;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';
import 'package:dogma_codegen/src/analyzer/analyzer_metadata.dart';
import 'package:dogma_codegen/src/analyzer/context.dart';
import 'package:test/test.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Finds a converter function.
ConverterFunctionMetadata _findConverterFunction(LibraryMetadata metadata, String name)
    => metadata.functions.firstWhere(
        (function) => function.name == name,
        orElse: () => null) as ConverterFunctionMetadata;

/// Finds an enumeration.
EnumMetadata _findEnum(LibraryMetadata metadata, String name)
    => metadata.enumerations.firstWhere(
        (enumeration) => enumeration.name == name,
        orElse: () => null);

/// Test entry point.
void main() {
  var context = analysisContext();

  test('Empty library', () {
    var metadata = libraryMetadata('test/libs/empty.dart', context);

    expect(metadata, null);
  });

  test('FunctionMetadata explicit', () {
    var metadata = libraryMetadata('test/libs/converter_functions_explicit.dart', context);

    expect(metadata.imported.isEmpty, true);
    expect(metadata.exported.isEmpty, true);
    expect(metadata.models.isEmpty, true);
    expect(metadata.converters.isEmpty, true);
    expect(metadata.enumerations.isEmpty, true);
    expect(metadata.functions.length, 2);

    var decoder = _findConverterFunction(metadata, 'decodeDuration');
    expect(decoder.isDecoder, true);
    expect(decoder.isDefaultConverter, true);

    var encoder = _findConverterFunction(metadata, 'encodeDuration');
    expect(encoder.isDecoder, false);
    expect(encoder.isDefaultConverter, true);
  });

  test('FunctionMetadata implicit', () {
    var metadata = libraryMetadata('test/libs/converter_functions_implicit.dart', context);

    expect(metadata.imported.isEmpty, true);
    expect(metadata.exported.isEmpty, true);
    expect(metadata.models.isEmpty, true);
    expect(metadata.converters.isEmpty, true);
    expect(metadata.enumerations.isEmpty, true);
    expect(metadata.functions.length, 2);

    var decoder = _findConverterFunction(metadata, 'decodeDuration');
    expect(decoder.isDecoder, true);
    expect(decoder.isDefaultConverter, false);

    var encoder = _findConverterFunction(metadata, 'encodeDuration');
    expect(encoder.isDecoder, false);
    expect(encoder.isDefaultConverter, false);
  });

  test('EnumMetadata explicit', () {
    var metadata = libraryMetadata('test/libs/enum_explicit.dart', context);

    expect(metadata.imported.isEmpty, true);
    expect(metadata.exported.isEmpty, true);
    expect(metadata.models.isEmpty, true);
    expect(metadata.converters.isEmpty, true);
    expect(metadata.enumerations.length, 1);
    expect(metadata.functions.isEmpty, true);

    var enumeration =_findEnum(metadata, 'ColorExplicit');
    var mapping = enumeration.serializeAnnotation.mapping;
    expect(mapping.values, ['red', 'green', 'blue']);
    expect(mapping.keys, [0xff0000, 0xff00, 0xff]);
  });

  test('EnumMetadata implicit', () {
    var metadata = libraryMetadata('test/libs/enum_implicit.dart', context);

    expect(metadata.imported.isEmpty, true);
    expect(metadata.exported.isEmpty, true);
    expect(metadata.models.isEmpty, true);
    expect(metadata.converters.isEmpty, true);
    expect(metadata.enumerations.length, 1);
    expect(metadata.functions.isEmpty, true);

    var enumeration = _findEnum(metadata, 'ColorImplicit');
    expect(enumeration.values, ['red', 'green', 'blue']);
    expect(enumeration.encoded, enumeration.values);
  });

  test('ModelMetadata explicit', () {
    var metadata = libraryMetadata('test/libs/model_explicit.dart', context);

    expect(metadata.imported.isEmpty, true);
    expect(metadata.exported.isEmpty, true);
    expect(metadata.models.length, 1);
    expect(metadata.converters.isEmpty, true);
    expect(metadata.enumerations.isEmpty, true);
    expect(metadata.functions.isEmpty, true);

    var model = metadata.models.firstWhere((value) => value.name == 'Explicit');
    var convertibleFields = model.convertibleFields.toList();
    var decodableFields = model.decodableFields.toList();
    var encodableFields = model.encodableFields.toList();
  });
}
