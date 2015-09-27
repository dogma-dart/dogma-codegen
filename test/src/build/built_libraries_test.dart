// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains tests for the [FunctionMetadata] class.
library dogma_codegen.test.src.build.built_libraries_test;

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:async';

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:test/test.dart';
import 'package:dogma_codegen/metadata.dart';
import 'package:dogma_codegen/path.dart';
import 'package:dogma_codegen/src/build/io.dart';
import 'package:dogma_codegen/src/build/models.dart';
import 'package:dogma_codegen_test/isolate_test.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

LibraryMetadata _modelsLibrary() {
  var exported = [
    _enumLibrary()
  ];

  return new LibraryMetadata(
    'dogma_codegen.test.libs.model',
    join('test/libs/models.dart'),
    exported: exported
  );
}

LibraryMetadata _enumLibrary() {
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

/// Test entry point.
void main() {
  var modelsLibrary = _modelsLibrary();

  setUp(() async {
    await createDirectory('test/libs/src/models');
    await writeModels(modelsLibrary);
  });

  testInIsolate('Models', join('test/src/generated/model_test.dart'));
}
