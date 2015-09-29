// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains metadata for the ModelImplicit class and library.
library dogma_codegen.test.src.build.model_implicit_library;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';
import 'package:dogma_codegen/path.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Gets a library containing the ModelImplicit class.
LibraryMetadata modelImplicitLibrary() =>
    new LibraryMetadata(
        'dogma_codegen.test.libs.src.models.model_implicit',
        join('test/libs/src/models/model_implicit.dart'),
        models: [modelImplicitMetadata()]);

/// Metadata for the ModelImplicit class.
ModelMetadata modelImplicitMetadata() {
  var fields = [
    new SerializableFieldMetadata.convertValue('n', new TypeMetadata.num()),
    new SerializableFieldMetadata.convertValue('i', new TypeMetadata.int()),
    new SerializableFieldMetadata.convertValue('d', new TypeMetadata.double()),
    new SerializableFieldMetadata.convertValue('b', new TypeMetadata.bool()),
    new SerializableFieldMetadata.convertValue('s', new TypeMetadata.string()),
    new SerializableFieldMetadata.convertValue(
        'l',
        new TypeMetadata.list(new TypeMetadata.num())
    ),
    new SerializableFieldMetadata.convertValue(
        'm',
        new TypeMetadata.map(new TypeMetadata.string(), new TypeMetadata.num())
    )
  ];

  return new ModelMetadata('ModelImplicit', fields);
}
