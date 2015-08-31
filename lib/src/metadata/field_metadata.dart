// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [FieldMetadata] class.
library dogma_codegen.src.metadata.field_metadata;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'annotated.dart';
import 'commented.dart';
import 'metadata.dart';
import 'type_metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Contains metadata for a field within a model.
///
/// The field metadata contains serialization information for generating
/// converters for the model holding the field.
class FieldMetadata extends Metadata {
  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// The type information for the field.
  final TypeMetadata type;
  /// Whether the field should be decoded.
  final bool decode;
  /// Whether the field should be encoded.
  final bool encode;
  /// Comments for the field.
  final String comments;
  /// The serialization name.
  final String _serializationName;

  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Creates an instance of [FieldMetadata] with the given [name] and [type].
  ///
  /// Serialization is specified in the [decode] and [encode] fields. If the
  /// name to serialize to is different than the name of field then
  /// [serializationName] should be specified.
  ///
  /// Additionally code comments can be provided through [comments].
  FieldMetadata(String name, this.type, this.decode, this.encode, {String serializationName, this.comments: ''})
      :  _serializationName = serializationName ?? ''
      , super(name);

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// The name to use when serializing.
  ///
  /// If the serialization name was specified during construction that will be
  /// used; otherwise this will return the same value as [name].
  String get serializationName => _serializationName.isNotEmpty ? _serializationName : name;
}

/// Contains metadata for a field within a class.
///
/// A field can either be a member variable declaration or a property. This
/// follows the behavior of the analyzer which returns properties as fields on
/// the class.
///
/// This behavior is different from a how dart:mirrors behaves as properties
/// are considered methods and member variables are considered variables.
class FieldMetadata2 extends Metadata implements Annotated, Commented {
  //---------------------------------------------------------------------
  // Library contents
  //---------------------------------------------------------------------

  /// The type information for the field.
  final TypeMetadata type;
  /// Whether the field is a property (getter and/or setter).
  final bool isProperty;
  /// Whether the field has a getter.
  final bool getter;
  /// Whether the field has a setter.
  final bool setter;

  //---------------------------------------------------------------------
  // Annotated
  //---------------------------------------------------------------------

  @override
  final List annotations;

  //---------------------------------------------------------------------
  // Commented
  //---------------------------------------------------------------------

  @override
  final String comments;

  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Creates an instance of the [FieldMetadata] class with the given [name].
  FieldMetadata2(String name,
                 this.type,
                 this.isProperty,
                 this.getter,
                 this.setter,
                {this.annotations: const [],
                 this.comments: ''})
      : super(name);
}
