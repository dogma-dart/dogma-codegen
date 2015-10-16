// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [ConstructorMetadata] class.
library dogma_codegen.src.metadata.constructor_metadata;

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
class ConstructorMetadata extends FunctionMetadata {
  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// Whether the constructor is a factory constructor.
  final bool isFactory;

  //---------------------------------------------------------------------
  // Constructor
  //---------------------------------------------------------------------

  /// Creates an instance of [ConstructorMetadata] referencing a default
  /// constructor of the [returnType].
  ConstructorMetadata(TypeMetadata returnType,
                     {List<ParameterMetadata> parameters,
                      this.isFactory: false,
                      List annotations,
                      String comments})
      : super('',
              returnType,
              parameters: parameters,
              annotations: annotations,
              comments: comments);


  /// Creates an instance of [ConstructorMetadata] with the given [name] and
  /// [returnType].
  ConstructorMetadata.named(String name,
                            TypeMetadata returnType,
                           {List<ParameterMetadata> parameters,
                            this.isFactory: false,
                            List annotations,
                            String comments})
      : super(name,
              returnType,
              parameters: parameters,
              annotations: annotations,
              comments: comments);

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// Whether the constructor is the default constructor.
  bool get isDefault => name.isEmpty;
}
