// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains metadata for the ModelBuiltinFunctions class and library.
///
/// This tests models that use builtin dart types that can be converted
/// automatically.
///
/// The following types are supported.
///
/// * DateTime
/// * Uri
library dogma_codegen.test.src.build.model_builtin_functions_library;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';
import 'package:dogma_codegen/path.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Gets a library containing the ModelBuiltinFunctions class.
LibraryMetadata modelBuiltinFunctionsLibrary() =>
    new LibraryMetadata(
        'dogma_codegen.test.libs.src.models.model_builtin_functions',
        join('test/libs/src/models/model_builtin_functions.dart'),
        models: [modelBuiltinFunctionsMetadata()]);

/// Metadata for the ModelBuiltinFunctions class.
ModelMetadata modelBuiltinFunctionsMetadata() {
  var fields = [
    new SerializableFieldMetadata.convertValue('d', new TypeMetadata('DateTime')),
    new SerializableFieldMetadata.convertValue('u', new TypeMetadata('Uri'))
  ];

  return new ModelMetadata('ModelBuiltinFunctions', fields);
}
