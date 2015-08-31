// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [QueryMetadata] class and functions for querying its contents.
library dogma_codegen.src.metadata.query_metadata;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'class_metadata.dart';
import 'field_metadata.dart';
import 'type_metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

class QueryMetadata extends ClassMetadata {
  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Creates an instance of [QueryMetadata] with the given [name].
  ///
  /// The [modelType] specifies the return type of a generated FluentQuery.
  QueryMetadata(String name,
                TypeMetadata modelType,
               {List<FieldMetadata> fields})
      : super(name, implements: [fluentQuery(modelType)], fields: fields);

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// The type of model the query returns.
  TypeMetadata get modelType => implements[0].arguments[0];

  //---------------------------------------------------------------------
  // Class methods
  //---------------------------------------------------------------------

  /// Creates a generic FluentQuery type from the [modelType].
  ///
  /// Used to generate the supertype of the [QueryMetadata].
  static TypeMetadata fluentQuery(TypeMetadata modelType)
      => new TypeMetadata('FluentQuery', arguments: [modelType]);
}
