// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [SerializableFieldMetadata] class.
library dogma_codegen.src.metadata.serializable_field_metadata;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_data/serialize.dart';

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

  /// Creates an instance of the [SerializableFieldMetadata] with the given
  /// [name].
  SerializableFieldMetadata(String name,
                            TypeMetadata type,
                            bool decode,
                            bool encode,
                           {String serializationName: '',
                            bool optional: false,
                            dynamic defaultsTo,
                            String comments: ''})
      : super(name,
              type,
              false, // Allows a field
              true,  // Field has a getter
              true,  // Field has a setter
              comments: comments,
              annotations: [new Serialize.field(
                  serializationName.isEmpty ? name : serializationName,
                  encode: encode,
                  decode: decode,
                  optional: optional,
                  defaultsTo: defaultsTo)]);

  /// Creates an instance of the [SerializableFieldMetadata] with the given
  /// [name] whose serialization is specified through an [annotation].
  SerializableFieldMetadata.annotated(String name,
                                      TypeMetadata type,
                                      Serialize annotation,
                                     {String comments: ''})
      : super(name,
             type,
             false, // Allows a field
             true,  // Field has a getter
             true,  // Field has a setter
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
  /// Whether the field is optional.
  bool get optional => serializeAnnotation.optional;
  /// The default value for the field.
  ///
  /// This is only valid if [optional] is set to true.
  dynamic get defaultsTo => serializeAnnotation.optional;
}
