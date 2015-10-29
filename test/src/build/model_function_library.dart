// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains metadata for the ModelFunction class and library.
///
/// This tests using default converter functions and overriding their behavior.
library dogma_codegen.test.src.build.model_function_library;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';
import 'package:dogma_codegen/path.dart';
import 'package:dogma_codegen/src/build/libraries.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Gets a library containing the ModelBuiltinFunctions class.
  LibraryMetadata modelFunctionLibrary() =>
      new LibraryMetadata(
          'dogma_codegen.test.libs.src.models.model_function',
          join('test/libs/src/models/model_function.dart'),
          imported: [dogmaSerialize],
          models: [modelFunctionMetadata()]);

  /// Metadata for the ModelBuiltinFunctions class.
  ModelMetadata modelFunctionMetadata() {
    var duration = new TypeMetadata('Duration');

    var fields = <SerializableFieldMetadata>[
      new SerializableFieldMetadata.convertValue('d', duration),
      new SerializableFieldMetadata.convertUsing(
          'od',
          duration,
          'decodeDurationInMinutes',
          'encodeDurationInMinutes'
      )
    ];

  return new ModelMetadata('ModelFunction', fields);
}
