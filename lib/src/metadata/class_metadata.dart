// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [ClassMetadata] class.
library dogma_codegen.src.metadata.class_metadata;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'annotated.dart';
import 'commented.dart';
import 'field_metadata.dart';
import 'metadata.dart';
import 'type_metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Contains metadata for a class.
class ClassMetadata extends Metadata implements Annotated, Commented {
  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// The type of the class.
  final TypeMetadata type;
  /// The parent class type.
  final TypeMetadata supertype;
  /// The types this class implements.
  final List<TypeMetadata> implements;
  /// The type parameters for the class.
  final List<TypeMetadata> typeParameters;
  /// The fields for the class.
  final List<FieldMetadata> fields;

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

  /// Creates an instance of [ClassMetadata] with the given [name].
  ///
  /// The class hierarchy can be specified with the [superclass]. Additionally
  /// interfaces that the class conforms to can be specified in [implements].
  ///
  /// Currently this is implementation is ignoring mixins so this information
  /// is not available to query.
  ClassMetadata(String name,
               {this.supertype,
                this.implements: const [],
                this.typeParameters: const [],
                this.fields: const [],
                this.annotations: const [],
                this.comments: ''})
      : type = new TypeMetadata(name)
      , super(name);
}
