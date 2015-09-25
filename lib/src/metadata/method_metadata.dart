// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [MethodMetadata] class.
library dogma_codegen.src.metadata.method_metadata;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'function_metadata.dart';
import 'parameter_metadata.dart';
import 'type_metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Contains metadata for a method.
class MethodMetadata extends FunctionMetadata {
  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// Whether the method is a class method.
  final bool isStatic;

  //---------------------------------------------------------------------
  // Constructor
  //---------------------------------------------------------------------

  /// Creates an instance of [MethodMetadata] with the given [name] and
  /// [returnType].
  MethodMetadata(String name,
                 TypeMetadata returnType,
                {List<ParameterMetadata> parameters: const [],
                 this.isStatic: false,
                 List annotations: const [],
                 String comments: ''})
      : super(name,
              returnType,
              parameters: parameters,
              annotations: annotations,
              comments: comments);
}
