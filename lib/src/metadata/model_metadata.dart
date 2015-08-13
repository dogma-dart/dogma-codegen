// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [ModelMetadata] class and functions for querying its contents.
library dogma_codegen.src.metadata.model_metadata;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'field_metadata.dart';
import 'metadata.dart';
import 'type_metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

///
class ModelMetadata extends Metadata {
  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// The fields present on the model.
  final List<FieldMetadata> fields;

  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  ModelMetadata(String name, this.fields)
      : super(name);

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// Whether the model uses explicit serialization.
  ///
  /// Looks for any cases where the field name differs from the serialization
  /// name. If there are differences in any fields then the model uses explicit
  /// serialization.
  bool get explicitSerialization {
    for (var field in fields) {
      if ((field.decode || field.encode) && (field.name != field.serializationName)) {
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

  /// Gets the fields that are convertable within the model.
  Iterable<FieldMetadata> get convertableFields
      => fields.where((field) => field.decode || field.encode);

  /// Gets the fields that are decodable within the model.
  Iterable<FieldMetadata> get decodableFields
      => fields.where((field) => field.decode);

  /// Get the fields that are encodable within the model.
  Iterable<FieldMetadata> get encodableFields
      => fields.where((field) => field.encode);

  /// Get the fields that are list types.
  Iterable<FieldMetadata> get listFields
      => fields.where((field) => field.type.isList);

  /// Get the fields that are map types.
  Iterable<FieldMetadata> get mapFields
      => fields.where((field) => field.type.isMap);
}

/// Retrieves all the dependent types from the [metadata].
Iterable<TypeMetadata> modelDependencies(ModelMetadata metadata)
    => _dependencies(metadata.fields);

/// Retrieves all the dependent types for converters from the [metadata].
Iterable<TypeMetadata> modelConverterDependencies(ModelMetadata metadata)
    => _dependencies(metadata.convertableFields);

/// Retrieves all the dependent types for decoders from the [metadata].
Iterable<TypeMetadata> modelDecoderDependencies(ModelMetadata metadata)
    => _dependencies(metadata.decodableFields);

/// Retrieves all the dependent types for encoders from the [metadata].
Iterable<TypeMetadata> modelEncoderDependencies(ModelMetadata metadata)
    => _dependencies(metadata.encodableFields);

Iterable<TypeMetadata> _dependencies(Iterable<FieldMetadata> fields) sync* {
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
  var values = [];

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
