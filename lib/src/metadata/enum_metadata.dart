// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [EnumMetadata] class.
library dogma_codegen.src.metadata.enum_metadata;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_convert/serialize.dart';

import 'enum_field_metadata.dart';
import 'class_metadata.dart';
import 'type_metadata.dart';
import 'serialize_annotated.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Contains metadata for an enumeration.
class EnumMetadata extends ClassMetadata implements SerializeAnnotated {
  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Creates an instance of [EnumMetadata] with the given [name] and [values].
  ///
  /// If there is a specific encoding for the values then [encoded] should be
  /// provided, otherwise the individual [values] will be used as the
  /// serialized names.
  factory EnumMetadata(String name,
                       List<String> values,
                      {List encoded,
                       String comments,
                       List<String> valueComments})
  {
    var count = values.length;

    encoded ??= new List<String>.from(values);
    valueComments ??= new List<String>.filled(count, '');

    var mapping = {};
    var fields = <EnumFieldMetadata>[];
    var enumType = new TypeMetadata(name);

    for (var i = 0; i < count; ++i) {
      var field = new EnumFieldMetadata(
          values[i],
          enumType,
          comments: valueComments[i]
      );

      mapping[encoded[i]] = field;
      fields.add(field);
    }

    var annotation = new Serialize.values(mapping);

    return new EnumMetadata.annotated(
        name,
        fields,
        annotation,
        comments: comments
    );
  }

  /// Creates an instance of the [EnumMetadata] with the given [name] whose
  /// serialization is specified through an [annotation].
  EnumMetadata.annotated(String name,
                         List<EnumFieldMetadata> fields,
                         Serialize annotation,
                        {String comments})
      : super(name,
              fields: fields,
              annotations: [annotation],
              comments: comments);

  //---------------------------------------------------------------------
  // SerializeAnnotated
  //---------------------------------------------------------------------

  @override
  Serialize get serializeAnnotation => findSerializeAnnotation(annotations);

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// Whether the enum uses explicit serialization.
  ///
  /// Compares the values in the annotation to determine if any there are any
  /// differences.
  bool get explicitSerialization {
    var values = serializeAnnotation.mapping;
    var explicit = false;

    values.forEach((encoded, value) {
      if (encoded != value.name) {
        explicit = true;
        return;
      }
    });

    return explicit;
  }

  /// The type of the encoded values.
  TypeMetadata get encodeType
      => new TypeMetadata.runtimeType(
          serializeAnnotation.mapping.keys.first);
}
