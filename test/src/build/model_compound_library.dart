// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains metadata for the ModelCompound class and library.
///
/// This tests models which serialize other models.
library dogma_codegen.test.src.build.model_compound_library;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';
import 'package:dogma_codegen/path.dart';

import 'model_implicit_library.dart';
import 'enum_implicit_library.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Gets a library containing the ModelCompound class.
LibraryMetadata modelCompoundLibrary() =>
    new LibraryMetadata(
        'dogma_codegen.test.libs.src.models.model_compound',
        join('test/libs/src/models/model_compound.dart'),
        imported: [modelImplicitLibrary(), enumImplicitLibrary()],
        models: [modelCompoundMetadata()]);

/// Metadata for the ModelCompound class.
ModelMetadata modelCompoundMetadata() {
  var fields = [
    new SerializableFieldMetadata.convertValue('m', new TypeMetadata('ModelImplicit')),
    new SerializableFieldMetadata.convertValue('e', new TypeMetadata('ColorImplicit'))
  ];

  return new ModelMetadata('ModelCompound', fields);
}
