// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.test.src.analyzer.analyzer_metadata_test;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:cli_util/cli_util.dart';
import 'package:dogma_codegen/src/analyzer/analyzer_metadata.dart';
import 'package:dogma_codegen/src/analyzer/context.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Test entry point.
void main() {
  var context = analysisContext(path.current, getSdkDir().path);

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

    var decoder = metadata.functions.firstWhere((function) => function.name == 'decodeDuration');
    expect(decoder.decoder, true);
    expect(decoder.defaultConverter, true);

    var encoder = metadata.functions.firstWhere((function) => function.name == 'encodeDuration');
    expect(encoder.decoder, false);
    expect(encoder.defaultConverter, true);
  });

  test('FunctionMetadata implicit', () {
    var metadata = libraryMetadata('test/libs/converter_functions_implicit.dart', context);

    expect(metadata.imported.isEmpty, true);
    expect(metadata.exported.isEmpty, true);
    expect(metadata.models.isEmpty, true);
    expect(metadata.converters.isEmpty, true);
    expect(metadata.enumerations.isEmpty, true);
    expect(metadata.functions.length, 2);

    var decoder = metadata.functions.firstWhere((function) => function.name == 'decodeDuration');
    expect(decoder.decoder, null);
    expect(decoder.defaultConverter, false);

    var encoder = metadata.functions.firstWhere((function) => function.name == 'encodeDuration');
    expect(encoder.decoder, null);
    expect(encoder.defaultConverter, false);
  });

  test('EnumMetadata explicit', () {
    var metadata = libraryMetadata('test/libs/enum_explicit.dart', context);

    expect(metadata.imported.isEmpty, true);
    expect(metadata.exported.isEmpty, true);
    expect(metadata.models.isEmpty, true);
    expect(metadata.converters.isEmpty, true);
    expect(metadata.enumerations.length, 1);
    expect(metadata.functions.isEmpty, true);

    var enumeration = metadata.enumerations.firstWhere((value) => value.name == 'ColorExplicit');
    expect(enumeration.values, ['red', 'green', 'blue']);
    expect(enumeration.encoded, [0xff0000, 0xff00, 0xff]);
  });

  test('EnumMetadata implicit', () {
    var metadata = libraryMetadata('test/libs/enum_implicit.dart', context);

    expect(metadata.imported.isEmpty, true);
    expect(metadata.exported.isEmpty, true);
    expect(metadata.models.isEmpty, true);
    expect(metadata.converters.isEmpty, true);
    expect(metadata.enumerations.length, 1);
    expect(metadata.functions.isEmpty, true);

    var enumeration = metadata.enumerations.firstWhere((value) => value.name == 'ColorImplicit');
    expect(enumeration.values, ['red', 'green', 'blue']);
    expect(enumeration.encoded, enumeration.values);
  });
}
