// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains metadata for the ModelOptional class and library.
///
/// This tests models where values are optionally serialized.
library dogma_codegen.test.src.build.model_optional_library;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';
import 'package:dogma_codegen/path.dart';
import 'package:dogma_codegen/src/build/libraries.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Gets a library containing the ModelOptional class.
LibraryMetadata modelOptionalLibrary() =>
    new LibraryMetadata(
        'dogma_codegen.test.libs.src.models.model_optional',
        join('test/libs/src/models/model_optional.dart'),
        imported: [dogmaSerialize],
        models: [modelOptionalMetadata()]);

/// Metadata for the ModelOptional class.
ModelMetadata modelOptionalMetadata() {
  var fields = [
    new SerializableFieldMetadata.convertValue(
        'n',
        new TypeMetadata.num(),
        optional: true,
        defaultsTo: 1.0
    ),
    new SerializableFieldMetadata.convertValue(
        'i',
        new TypeMetadata.int(),
        optional: true,
        defaultsTo: 2
    ),
    new SerializableFieldMetadata.convertValue(
        'd',
        new TypeMetadata.double(),
        optional: true,
        defaultsTo: 3.0
    ),
    new SerializableFieldMetadata.convertValue(
        'b',
        new TypeMetadata.bool(),
        optional: true,
        defaultsTo: true
    ),
    new SerializableFieldMetadata.convertValue(
        's',
        new TypeMetadata.string(),
        optional: true,
        defaultsTo: 'foo'
    ),
    new SerializableFieldMetadata.convertValue(
        'l',
        new TypeMetadata.list(new TypeMetadata.num()),
        optional: true,
        defaultsTo: [0, 1, 2, 3, 4]
    ),
    new SerializableFieldMetadata.convertValue(
        'm',
        new TypeMetadata.map(new TypeMetadata.string(), new TypeMetadata.num()),
        optional: true,
        defaultsTo: {'a': 0.0, 'b': 1.0}
    )
  ];

  return new ModelMetadata('ModelOptional', fields);
}
