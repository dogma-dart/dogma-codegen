// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains tests for the [FunctionMetadata] class.
library dogma_codegen.test.src.build.built_libraries_test;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:test/test.dart';
import 'package:dogma_codegen/metadata.dart';
import 'package:dogma_codegen/path.dart';
import 'package:dogma_codegen/src/build/converters.dart';
import 'package:dogma_codegen/src/build/io.dart';
import 'package:dogma_codegen/src/build/libraries.dart';
import 'package:dogma_codegen/src/build/models.dart';
import 'package:dogma_codegen_test/isolate_test.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

LibraryMetadata _modelsLibrary() {
  var exported = [
    _enumImplicitLibrary(),
    _enumExplicitLibrary()
  ];

  return new LibraryMetadata(
    'dogma_codegen.test.libs.models',
    join('test/libs/models.dart'),
    exported: exported
  );
}

LibraryMetadata _enumImplicitLibrary() {
  var values = [
    'red',
    'green',
    'blue'
  ];

  var enumeration = new EnumMetadata('ColorImplicit', values);

  return new LibraryMetadata(
      'dogma_codegen.test.libs.src.models.color_implicit',
      join('test/libs/src/models/color_implicit.dart'),
      enumerations: [enumeration]
  );
}

LibraryMetadata _enumExplicitLibrary() {
  var enumeration = new EnumMetadata(
      'ColorExplicit',
      ['red', 'green', 'blue'],
      encoded: [0xff0000, 0x00ff00, 0x0000ff]
  );

  return new LibraryMetadata(
      'dogma_codegen.test.libs.src.models.color_explicit',
      join('test/libs/src/models/color_explicit.dart'),
      imported: [dogmaSerialize],
      enumerations: [enumeration]
  );
}

/// Test entry point.
void main() {
  var modelsLibrary = _modelsLibrary();

  group('Models', () {
    setUp(() async {
    await createDirectory('test/libs/src/models');
    await writeModels(modelsLibrary);
    });

    testInIsolate('generated code', join('test/src/generated/model_test.dart'));
  });

  group('Convert', () {
    setUp(() async {
      await buildConverters(
          modelsLibrary,
          join('test/libs/convert.dart'),
          join('test/libs/src/convert')
      );
    });

    testInIsolate('generated code', join('test/src/generated/convert_test.dart'));
  });
}
