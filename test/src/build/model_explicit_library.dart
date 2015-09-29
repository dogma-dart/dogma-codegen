// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains metadata for the ModelExplicit class and library.
///
/// This tests models with explicit serialization where the serialization names
/// are specified.
library dogma_codegen.test.src.build.model_explicit_library;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';
import 'package:dogma_codegen/path.dart';
import 'package:dogma_codegen/src/build/libraries.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Gets a library containing the ModelExplicit class.
LibraryMetadata modelExplicitLibrary() =>
    new LibraryMetadata(
        'dogma_codegen.test.libs.src.models.model_explicit',
        join('test/libs/src/models/model_explicit.dart'),
        imported: [dogmaSerialize],
        models: [modelExplicitMetadata()]);

/// Metadata for the ModelImplicit class.
ModelMetadata modelExplicitMetadata() {
  var fields = [
    new SerializableFieldMetadata.convertValue(
        'n',
        new TypeMetadata.num(),
        serializationName: 'num'
    ),
    new SerializableFieldMetadata.convertValue(
        'i',
        new TypeMetadata.int(),
        serializationName: 'int'
    ),
    new SerializableFieldMetadata.convertValue(
        'd',
        new TypeMetadata.double(),
        serializationName: 'double'
    ),
    new SerializableFieldMetadata.convertValue(
        'b',
        new TypeMetadata.bool(),
        serializationName: 'bool'
    ),
    new SerializableFieldMetadata.convertValue(
        's',
        new TypeMetadata.string(),
        serializationName: 'string'
    ),
    new SerializableFieldMetadata.convertValue(
        'l',
        new TypeMetadata.list(new TypeMetadata.num()),
        serializationName: 'numList'
    ),
    new SerializableFieldMetadata.convertValue(
        'm',
        new TypeMetadata.map(new TypeMetadata.string(), new TypeMetadata.num()),
        serializationName: 'stringNumMap'
    )
  ];

  return new ModelMetadata('ModelExplicit', fields);
}
