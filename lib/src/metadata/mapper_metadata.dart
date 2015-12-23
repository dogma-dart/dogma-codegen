// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [MapperMetadata] class.
library dogma_codegen.src.metadata.mapper_metadata;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'converter_metadata.dart';
import 'class_metadata.dart';
import 'type_metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Contains metadata for a mapper.
class MapperMetadata extends ClassMetadata {
  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Creates an instance of [ConverterMetadata] for the given [type].
  ///
  /// Whether or not the converter will handle decoding is specified in
  /// [decoder].
  MapperMetadata(String name, TypeMetadata modelType)
      : super(name, supertype: mapper(modelType));

  /// Creates an instance of [MapperMetadata] for the given [modelType].
  MapperMetadata.type(TypeMetadata modelType)
      : super(defaultMapperName(modelType), supertype: mapper(modelType));

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// The model type associated with the mapper.
  TypeMetadata get modelType => supertype.arguments[0];

  //---------------------------------------------------------------------
  // Class methods
  //---------------------------------------------------------------------

  /// Gets the type for a mapper with the given [modelType].
  static TypeMetadata mapper(TypeMetadata modelType) {
    var arguments = <TypeMetadata>[modelType];

    return new TypeMetadata('Mapper', arguments: arguments);
  }

  /// Gets the default name for a mapper with the given [modelType].
  static String defaultMapperName(TypeMetadata modelType) =>
      '${modelType.name}Mapper';
}
