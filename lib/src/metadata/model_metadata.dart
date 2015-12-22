// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [ModelMetadata] class and functions for querying its contents.
library dogma_codegen.src.metadata.model_metadata;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'class_metadata.dart';
import 'field_metadata.dart';
import 'serializable_field_metadata.dart';
import 'type_metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Contains metadata for a model.
class ModelMetadata extends ClassMetadata {
  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Creates an instance of the [ModelMetadata] class with the given [name]
  /// and the given [fields].
  ModelMetadata(String name,
                List<FieldMetadata> fields,
               {String comments})
      : super(name, fields: fields, comments: comments);

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// Whether the model uses explicit serialization.
  ///
  /// Looks for any cases where the field name differs from the serialization
  /// name. If there are differences in any fields then the model uses explicit
  /// serialization.
  bool get explicitSerialization {
    for (var field in serializableFields) {
      if (!field.decode ||
          !field.encode ||
          (field.decodeUsing != null) ||
          (field.encodeUsing != null) ||
          (field.name != field.serializationName) ||
           field.optional) {
        return true;
      }
    }

    return false;
  }

  /// Whether the model uses a list type.
  bool get usesList {
    for (var field in fields) {
      if (field.type.isList) {
        return true;
      }
    }

    return false;
  }

  /// Whether the model uses a map type.
  bool get usesMap {
    for (var field in fields) {
      if (field.type.isMap) {
        return true;
      }
    }

    return false;
  }

  Iterable<SerializableFieldMetadata> get serializableFields sync* {
    for (var field in fields) {
      if (field is SerializableFieldMetadata) {
        yield field;
      }
    }
  }

  /// Gets the fields that are convertible within the model.
  Iterable<SerializableFieldMetadata> get convertibleFields
      => serializableFields.where((field) => field.decode || field.encode);

  /// Gets the fields that are decodable within the model.
  Iterable<SerializableFieldMetadata> get decodableFields
      => serializableFields.where((field) => field.decode);

  /// Get the fields that are encodable within the model.
  Iterable<SerializableFieldMetadata> get encodableFields
      => serializableFields.where((field) => field.encode);

  /// Get the fields that are list types.
  Iterable<SerializableFieldMetadata> get listFields
      => serializableFields.where((field) => field.type.isList);

  /// Get the fields that are map types.
  Iterable<SerializableFieldMetadata> get mapFields
      => serializableFields.where((field) => field.type.isMap);
}

/// Retrieves the field from the [metadata] with the given [name].
///
/// If the field is not found then null is returned.
SerializableFieldMetadata findFieldByName(ModelMetadata metadata, String name) {
  return metadata.fields.firstWhere((field) => field.name == name, orElse: () => null);
}

/// Retrieves all the dependent types from the [metadata].
Iterable<TypeMetadata> modelDependencies(ModelMetadata metadata)
    => _dependencies(metadata.serializableFields);

/// Retrieves all the dependent types for converters from the [metadata].
Iterable<TypeMetadata> modelConverterDependencies(ModelMetadata metadata)
    => _dependencies(metadata.convertibleFields);

/// Retrieves all the dependent types for decoders from the [metadata].
Iterable<TypeMetadata> modelDecoderDependencies(ModelMetadata metadata)
    => _dependencies(metadata.decodableFields);

/// Retrieves all the dependent types for encoders from the [metadata].
Iterable<TypeMetadata> modelEncoderDependencies(ModelMetadata metadata)
    => _dependencies(metadata.encodableFields);

Iterable<TypeMetadata> _dependencies(Iterable<SerializableFieldMetadata> fields) sync* {
  var set = [];

  for (var field in fields) {
    for (var type in _userDefinedTypes(field.type)) {
      if (!set.contains(type)) {
        yield type;

        set.add(type);
      }
    }
  }
}

List<TypeMetadata> _userDefinedTypes(TypeMetadata metadata) {
  var values = <TypeMetadata>[];

  if (!metadata.isBuiltin) {
    if (metadata.isList) {
      values.addAll(_userDefinedTypes(metadata.arguments[0]));
    } else if (metadata.isMap) {
      var arguments = metadata.arguments;
      values.addAll(_userDefinedTypes(arguments[0]));
      values.addAll(_userDefinedTypes(arguments[1]));
    } else {
      values.add(metadata);
    }
  }

  return values;
}
