// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [ParmeterMetadata] class.
library dogma_codegen.src.metadata.parameter_metadata;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'metadata.dart';
import 'parameter_kind.dart';
import 'type_metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Contains metadata for a parameter on a function or method.
class ParameterMetadata extends Metadata {
  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// The type information for the field.
  final TypeMetadata type;
  /// The kind of parameter.
  final ParameterKind parameterKind;
  /// The default value of the parameter.
  final dynamic defaultValue;

  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// Creates an instance of [ParameterMetadata] with the given [name] and
  /// accepting the given [type].
  ///
  /// By default the [parameterKind] is set to required. If the parameter is
  /// optional then [defaultsTo] should be set unless null is desired for the
  /// default value.
  ParameterMetadata(String name,
                    this.type,
                   {this.parameterKind: ParameterKind.required,
                    this.defaultValue})
      : super(name);

  //---------------------------------------------------------------------
  // Properites
  //---------------------------------------------------------------------

  /// Whether the parameter is required by calling code.
  bool get isRequired => parameterKind == ParameterKind.required;
  /// Whether the parameter is optional for calling code.
  bool get isOptional => !isRequired;
}

/// Finds required values within the [parameters].
Iterable<ParameterMetadata> findRequiredParameters(List<ParameterMetadata> parameters)
    => parameters.where((parameter)
        => parameter.parameterKind == ParameterKind.required);

/// Finds optional values within the [parameters].
Iterable<ParameterMetadata> findOptionalParameters(List<ParameterMetadata> parameters)
    => parameters.where((parameter)
        => parameter.parameterKind == ParameterKind.optional);

/// Finds named values within the [parameters].
Iterable<ParameterMetadata> findNamedParameters(List<ParameterMetadata> parameters)
    => parameters.where((parameter)
        => parameter.parameterKind == ParameterKind.named);
