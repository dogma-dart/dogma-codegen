// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [SerializableFieldMetadata] class.
library dogma_codegen.src.metadata.enum_value_metadata;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'field_metadata.dart';
import 'type_metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

///
class EnumFieldMetadata extends FieldMetadata {
  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  EnumFieldMetadata(String name, TypeMetadata type, {String comments: ''})
      : super(name,
              type,
              true,  // is a property not a field
              true,  // has a getter
              false, // does not have a setter,
              isConst: true,
              isFinal: false,
              isStatic: true,
              comments: comments);

  @override
  String toString() => '${type.name}.$name';
}
