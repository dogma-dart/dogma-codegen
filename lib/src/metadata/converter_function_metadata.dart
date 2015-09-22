// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [ConverterFunctionMetadata] class.
library dogma_codegen.src.metadata.converter_function_metadata;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_data/serialize.dart';

import 'converter.dart';
import 'function_metadata.dart';
import 'parameter_metadata.dart';
import 'type_metadata.dart';
import 'serialize_annotated.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Contains metadata for a function that can be used for serialization.
///
/// The metadata is only for functions that take a single output and return a
/// single output. If the function should be used for all types then
/// [defaultConverter] will be true.
class ConverterFunctionMetadata extends FunctionMetadata
                                implements SerializeAnnotated, Converter
{
  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Creates an instance of [ConverterFunctionMetadata] with the given [name],
  /// [returnType], and [inputParameter].
  ///
  /// If the function has an optional field for setting a default value or for
  /// reusing a model then it should be specified in [modelParameter].
  ///
  /// If the function should be used by default when convertering a type then
  /// [isDefaultConverter] should be set to true.
  factory ConverterFunctionMetadata(String name,
                                    TypeMetadata returnType,
                                    ParameterMetadata inputParameter,
                                   {ParameterMetadata modelParameter,
                                    bool isDefaultConverter: false,
                                    String comments: ''})
  {
    var parameters = [inputParameter];

    if (modelParameter != null) {
      parameters.add(modelParameter);
    }

    var annotations = new List();

    if (isDefaultConverter) {
      annotations.add(Serialize.using);
    }

    return new ConverterFunctionMetadata._internal(
        name,
        returnType,
        parameters,
        annotations,
        comments
    );
  }

  /// Creates an instance of [ConverterFunctionMetadata].
  ConverterFunctionMetadata._internal(String name,
                                      TypeMetadata returnType,
                                      List<ParameterMetadata> parameters,
                                      List annotations,
                                      String comments)
      : super(name,
              returnType,
              parameters: parameters,
              annotations: annotations,
              comments: comments);

  //---------------------------------------------------------------------
  // Converter
  //---------------------------------------------------------------------

  @override
  bool get isEncoder => returnType.isBuiltin;
  @override
  bool get isDecoder => !isEncoder;
  @override
  TypeMetadata get modelType
      => isEncoder ? returnType : parameters[0].type;

  //---------------------------------------------------------------------
  // SerializeAnnotated
  //---------------------------------------------------------------------

  @override
  Serialize get serializeAnnotation => findSerializeAnnotation(annotations);

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// Whether this function should used by default for conversion.
  bool get isDefaultConverter => serializeAnnotation != null;
  /// Whether this function should be used by default for decoding.
  bool get isDefaultDecoder => isDefaultConverter && isDecoder;
  /// Whether this function should be used by default for encoding.
  bool get isDefaultEncoder => isDefaultConverter && isEncoder;
}
