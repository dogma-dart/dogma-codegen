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

import 'package:dogma_data/serialize.dart';
import 'package:test/test.dart';

import '../../libs/models.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

ClassMirror _getClass(Symbol library, Symbol clazz) {
  var libraryMirror = currentMirrorSystem().findLibrary(library);

  return libraryMirror.declarations[clazz];
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
}
