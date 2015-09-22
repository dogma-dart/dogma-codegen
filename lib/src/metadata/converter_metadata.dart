// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [ConverterMetadata] class.
library dogma_codegen.src.metadata.converter_metadata;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'class_metadata.dart';
import 'converter.dart';
import 'type_metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Contains metadata for a converter.
class ConverterMetadata extends ClassMetadata implements Converter {
  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Creates an instance of [ConverterMetadata] for the given [type].
  ///
  /// Whether or not the converter will handle decoding is specified in
  /// [decoder].
  ConverterMetadata(String name, TypeMetadata modelType, bool decoder)
      : super(name,
              supertype: converter(modelType, decoder),
              implements: [modelConverter(modelType, decoder)]);

  /// Creates a decodable instance of [ConverterMetadata] using the given
  /// [type].
  ///
  /// The name of the class is generated based on the [modelType].
  ConverterMetadata.decoder(TypeMetadata modelType)
      : super('${modelType.name}Decoder',
              supertype: converter(modelType, true),
              implements: [modelDecoder(modelType)]);

  /// Creates a decodable instance of [ConverterMetadata] using the given
  /// [type].
  ///
  /// The name of the class is generated based on the [modelType].
  ConverterMetadata.encoder(TypeMetadata modelType)
      : super('${modelType.name}Encoder',
              supertype: converter(modelType, true),
              implements: [modelDecoder(modelType)]);

  //---------------------------------------------------------------------
  // Converter
  //---------------------------------------------------------------------

  @override
  bool get isEncoder => !isDecoder;
  @override
  bool get isDecoder => implements[0].name == 'ModelDecoder';
  @override
  TypeMetadata get modelType => implements[0].arguments[0];

  //---------------------------------------------------------------------
  // Class methods
  //---------------------------------------------------------------------

  static TypeMetadata converter(TypeMetadata modelType, bool decoder) {
    var mapType = new TypeMetadata('Map');
    var arguments = decoder
        ? [mapType, modelType]
        : [modelType, mapType];

    return new TypeMetadata('Converter', arguments: arguments);
  }

  static TypeMetadata modelConverter(TypeMetadata modelType, bool decoder)
      => decoder ? modelDecoder(modelType) : modelEncoder(modelType);

  static TypeMetadata modelDecoder(TypeMetadata modelType)
      => new TypeMetadata('ModelDecoder', arguments: [modelType]);

  static TypeMetadata modelEncoder(TypeMetadata modelType)
      => new TypeMetadata('ModelEncoder', arguments: [modelType]);
}
