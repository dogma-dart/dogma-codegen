// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [SerializeAnnotated] interface.
library dogma_codegen.src.metadata.serialize_annotated;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_convert/serialize.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

// \TODO Change to a mixin if https://github.com/dart-lang/sdk/issues/15101 is resolved

/// Retrieves a [Serialize] annotation attached to metadata.
abstract class SerializeAnnotated {
  /// Gets the [Serialize] annotation attached to the metadata if present.
  Serialize get serializeAnnotation;
}

// \TODO Remove if mixin issue is resolved

/// Finds the [Serialize] annotation within a list of [annotations].
Serialize findSerializeAnnotation(List annotations)
    => annotations.firstWhere(
        (annotation) => annotation is Serialize, orElse: () => null);
