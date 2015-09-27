// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [FieldMetadata] class.
library dogma_codegen.src.metadata.field_metadata;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'annotated_metadata.dart';
import 'type_metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Contains metadata for a field within a class.
///
/// A field can either be a member variable declaration or a property. This
/// follows the behavior of the analyzer which returns properties as fields on
/// the class.
///
/// This behavior is different from a how dart:mirrors behaves as properties
/// are considered methods and member variables are considered variables.
class FieldMetadata extends AnnotatedMetadata {
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
  /// Whether the field is constant.
  final bool isConst;
  /// Whether the field is final.
  final bool isFinal;
  /// Whether the field is a class field.
  final bool isStatic;
  /// The default value of the field.
  ///
  /// This is used to write out any initialization of the field.
  final dynamic defaultValue;

  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Creates an instance of the [FieldMetadata] class with the given [name].
  FieldMetadata(String name,
                this.type,
                this.isProperty,
                this.getter,
                this.setter,
               {this.isConst: false,
                this.isFinal: false,
                this.isStatic: false,
                this.defaultValue,
                List annotations,
                String comments})
      : super(name, annotations, comments);

  FieldMetadata.field(String name,
                      this.type,
                     {this.isConst: false,
                      this.isFinal: false,
                      this.isStatic: false,
                      this.defaultValue,
                      List annotations,
                      String comments})
      : isProperty = false
      , getter = true
      , setter = true
      , super(name, annotations, comments);
}
