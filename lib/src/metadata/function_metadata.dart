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
import 'parameter_metadata.dart';
import 'type_metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Contains metadata for a function.
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
                  {List<ParameterMetadata> parameters,
                   List annotations,
                   String comments})
      : parameters = parameters ?? <ParameterMetadata>[]
      , super(name, annotations, comments);

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// The required parameters for the function.
  Iterable<ParameterMetadata> get requiredParameters =>
      findRequiredParameters(parameters);

  /// The optional parameters for the function.
  Iterable<ParameterMetadata> get optionalParameters =>
      findOptionalParameters(parameters);

  /// The named parameters for the function.
  Iterable<ParameterMetadata> get namedParameters =>
      findNamedParameters(parameters);
}
