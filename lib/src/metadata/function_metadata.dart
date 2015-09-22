// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [FunctionMetadata] class.
library dogma_codegen.src.metadata.function_metadata;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'annotated_metadata.dart';
import 'parameter_kind.dart';
import 'parameter_metadata.dart';
import 'type_metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Contains metadata for a function or method.
class FunctionMetadata extends AnnotatedMetadata {
  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// The return type of the function.
  final TypeMetadata returnType;
  /// The list of parameters for the function.
  final List<ParameterMetadata> parameters;

  //---------------------------------------------------------------------
  // Constructor
  //---------------------------------------------------------------------

  /// Creates an instance of [FunctionMetadata] with the given [name] and
  /// [returnType].
  FunctionMetadata(String name,
                   this.returnType,
                  {this.parameters: const [],
                   List annotations: const [],
                   String comments: ''})
      : super(name, annotations, comments);

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// The required parameters for the function.
  Iterable<ParameterMetadata> get requiredParameters
      => parameters.where((parameter)
          => parameter.parameterKind == ParameterKind.required);

  /// The optional parameters for the function.
  Iterable<ParameterMetadata> get optionalParameters
      => parameters.where((parameter)
          => parameter.parameterKind == ParameterKind.optional);

  /// The named parameters for the function.
  Iterable<ParameterMetadata> get namedParameters
      => parameters.where((parameter)
          => parameter.parameterKind == ParameterKind.named);
}
