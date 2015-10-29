// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains metadata for the ModelExplicitConvert class and library.
///
/// This tests models where only certain fields are encoded or decoded.
library dogma_codegen.test.src.build.model_explicit_convert_library;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';
import 'package:dogma_codegen/path.dart';
import 'package:dogma_codegen/src/build/libraries.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Gets a library containing the ModelExplicitConvert class.
LibraryMetadata modelExplicitConvertLibrary() =>
    new LibraryMetadata(
        'dogma_codegen.test.libs.src.models.model_explicit_convert',
        join('test/libs/src/models/model_explicit_convert.dart'),
        imported: [dogmaSerialize],
        models: [modelExplicitConvertMetadata()]);

/// Metadata for the ModelExplicitConvert class.
ModelMetadata modelExplicitConvertMetadata() {
  var fields = <SerializableFieldMetadata>[
    new SerializableFieldMetadata.decodeValue(
        'dI',
        new TypeMetadata.int()
    ),
    new SerializableFieldMetadata.decodeValue(
        'dS',
        new TypeMetadata.string()
    ),
    new SerializableFieldMetadata.decodeValue(
        'dL',
        new TypeMetadata.list(new TypeMetadata.num())
    ),
    new SerializableFieldMetadata.encodeValue(
        'eI',
        new TypeMetadata.int()
    ),
    new SerializableFieldMetadata.encodeValue(
        'eS',
        new TypeMetadata.string()
    ),
    new SerializableFieldMetadata.encodeValue(
        'eL',
        new TypeMetadata.list(new TypeMetadata.num())
    ),
  ];

  return new ModelMetadata('ModelExplicitConvert', fields);
}
