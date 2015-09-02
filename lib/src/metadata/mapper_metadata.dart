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
  // Member variables
  //---------------------------------------------------------------------

  /// The decoder the mapper uses.
  final ConverterMetadata decoder;
  /// The encoder the mapper uses.
  final ConverterMetadata encoder;

  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Creates an instance of [MapperMetadata] with the given name.
  ///
  /// If [decoder] is provided then the mapper can make queries for data. If
  /// [encoder] is provided then the mapper can execute commands on data.
  factory MapperMetadata(String name,
                        {ConverterMetadata decoder,
                         ConverterMetadata encoder})
  {
    var modelType = decoder != null
        ? decoder.modelType
        : encoder.modelType;

    return new MapperMetadata._internal(name, modelType, decoder, encoder);
  }

  /// Creates an instance of [MapperMetadata].
  ///
  /// For internal use by the factory constructor.
  MapperMetadata._internal(String name,
                           TypeMetadata modelType,
                           this.decoder,
                           this.encoder)
      : super(name, supertype: mapper(modelType));

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// The type of model the mapper accepts.
  TypeMetadata get modelType {
    return decoder != null
        ? decoder.modelType
        : encoder.modelType;
  }

  //---------------------------------------------------------------------
  // Class methods
  //---------------------------------------------------------------------

  /// Creates a generic Mapper type from the [modelType].
  ///
  /// Used to generate the supertype of the [MapperMetadata].
  static TypeMetadata mapper(TypeMetadata modelType)
      => new TypeMetadata('FluentQuery', arguments: [modelType]);
}
