// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [ClassMetadata] class.
library dogma_codegen.src.metadata.class_metadata;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'annotated_metadata.dart';
import 'constructor_metadata.dart';
import 'field_metadata.dart';
import 'method_metadata.dart';
import 'type_metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Contains metadata for a class.
class ClassMetadata extends AnnotatedMetadata {
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
  /// The methods for the class.
  final List<MethodMetadata> methods;
  /// The constructors for the class.
  final List<ConstructorMetadata> constructors;

  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Creates an instance of [ClassMetadata] with the given [name].
  ///
  /// The class hierarchy can be specified with the [superclass]. Additionally
  /// interfaces that the class conforms to can be specified in [implements].
  ///
  /// Currently this implementation is ignoring mixins so this information
  /// is not available to query.
  ClassMetadata(String name,
               {this.supertype,
                List<TypeMetadata> implements,
                List<TypeMetadata> typeParameters,
                List<FieldMetadata> fields,
                List<MethodMetadata> methods,
                List<ConstructorMetadata> constructors,
                List annotations,
                String comments})
      : type = new TypeMetadata(name)
      , implements = implements ?? <TypeMetadata>[]
      , typeParameters = typeParameters ?? <TypeMetadata>[]
      , fields = fields ?? <FieldMetadata>[]
      , methods = methods ?? <MethodMetadata>[]
      , constructors = constructors ?? <ConstructorMetadata>[]
      , super(name, annotations, comments);
}
