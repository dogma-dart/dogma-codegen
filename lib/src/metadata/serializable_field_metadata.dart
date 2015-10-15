// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [SerializableFieldMetadata] class.
library dogma_codegen.src.metadata.serializable_field_metadata;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_convert/serialize.dart';

import 'field_metadata.dart';
import 'type_metadata.dart';
import 'serialize_annotated.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Contains metadata for a field within a class that can be serialized.
class SerializableFieldMetadata extends FieldMetadata implements SerializeAnnotated {
  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Creates an instance of [SerializableFieldMetadata] with the given [name].
  SerializableFieldMetadata(String name,
                            TypeMetadata type,
                            bool decode,
                            bool encode,
                           {String serializationName: '',
                            bool optional: false,
                            dynamic defaultsTo,
                            String comments})
      : super.field(name,
                    type,
                    comments: comments,
                    annotations: [new Serialize.field(
                        serializationName.isEmpty ? name : serializationName,
                        encode: encode,
                        decode: decode,
                        optional: optional,
                        defaultsTo: defaultsTo)]);

  /// Creates an instance of [SerializableFieldMetadata] with the given [name]
  /// where the field should be encoded and decoded.
  SerializableFieldMetadata.convertValue(String name,
                                         TypeMetadata type,
                                        {String serializationName: '',
                                         bool optional: false,
                                         dynamic defaultsTo,
                                         String comments})
      : super.field(name,
                    type,
                    comments: comments,
                    annotations: [new Serialize.field(
                        serializationName.isEmpty ? name : serializationName,
                        decode: true,
                        encode: true,
                        optional: optional,
                        defaultsTo: defaultsTo)]);

  /// Creates an instance of [SerializableFieldMetadata] with the given [name]
  /// where the field should be decoded but not decoded.
  SerializableFieldMetadata.decodeValue(String name,
                                        TypeMetadata type,
                                       {String serializationName: '',
                                        bool optional: false,
                                        dynamic defaultsTo,
                                        String comments})
      : super.field(name,
                    type,
                    comments: comments,
                    annotations: [new Serialize.field(
                        serializationName.isEmpty ? name : serializationName,
                        decode: true,
                        encode: false,
                        optional: optional,
                        defaultsTo: defaultsTo)]);

  /// Creates an instance of [SerializableFieldMetadata] with the given [name]
  /// where the field should be encoded but not decoded.
  SerializableFieldMetadata.encodeValue(String name,
                                        TypeMetadata type,
                                       {String serializationName: '',
                                        bool optional: false,
                                        dynamic defaultsTo,
                                        String comments})
      : super.field(name,
                    type,
                    comments: comments,
                    annotations: [new Serialize.field(
                        serializationName.isEmpty ? name : serializationName,
                        decode: false,
                        encode: true,
                        optional: optional,
                        defaultsTo: defaultsTo)]);

  /// Creates an instance of [SerializableFieldMetadata] with the given [name]
  /// whose serialization is specified through functions.
  SerializableFieldMetadata.convertUsing(String name,
                                         TypeMetadata type,
                                         String decode,
                                         String encode,
                                        {String serializationName: '',
                                         bool optional: false,
                                         dynamic defaultsTo,
                                         String comments})
      : super.field(name,
                    type,
                    comments: comments,
                    annotations: [new Serialize.function(
                        serializationName.isEmpty ? name : serializationName,
                        decode: decode,
                        encode: encode,
                        optional: optional,
                        defaultsTo: defaultsTo)]);

  /// Creates an instance of [SerializableFieldMetadata] with the given [name]
  /// whose serialization is specified through an [annotation].
  SerializableFieldMetadata.annotated(String name,
                                      TypeMetadata type,
                                      Serialize annotation,
                                     {String comments})
      : super.field(name,
                    type,
                    comments: comments,
                    annotations: [annotation]);

  //---------------------------------------------------------------------
  // SerializeAnnotated
  //---------------------------------------------------------------------

  @override
  Serialize get serializeAnnotation => findSerializeAnnotation(annotations);

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// Whether the field should be decoded.
  bool get decode => serializeAnnotation.decode;
  /// Whether the field should be encoded.
  bool get encode => serializeAnnotation.encode;
  /// The name to use when serializing.
  ///
  /// If the serialization name was specified on the annotation that will be
  /// used; otherwise this will return the same value as [name].
  String get serializationName => serializeAnnotation.name;
  /// The function to use when decoding.
  String get decodeUsing => serializeAnnotation.decodeUsing;
  /// The function to use when encoding.
  String get encodeUsing => serializeAnnotation.encodeUsing;
  /// Whether the field is optional.
  bool get optional => serializeAnnotation.optional;
  /// The default value for the field.
  ///
  /// This is only valid if [optional] is set to true.
  dynamic get defaultsTo => serializeAnnotation.defaultsTo;
}
