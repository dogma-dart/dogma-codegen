// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains metadata for the ModelRecursive class and library.
///
/// This tests models that contain instances of themselves. This behavior is
/// found in tree structures.
library dogma_codegen.test.src.build.model_recursive_library;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';
import 'package:dogma_codegen/path.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Gets a library containing the ModelRecursive class.
LibraryMetadata modelRecursiveLibrary() =>
    new LibraryMetadata(
        'dogma_codegen.test.libs.src.models.model_recursive',
        join('test/libs/src/models/model_recursive.dart'),
        models: [modelImplicitMetadata()]);

/// Metadata for the ModelRecursive class.
ModelMetadata modelImplicitMetadata() {
  var fields = [
    new SerializableFieldMetadata.convertValue('s', new TypeMetadata.string()),
    new SerializableFieldMetadata.convertValue(
        'l',
        new TypeMetadata.list(new TypeMetadata('ModelRecursive'))
    ),
  ];

  return new ModelMetadata('ModelRecursive', fields);
}
