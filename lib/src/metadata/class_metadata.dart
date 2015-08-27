// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [ClassMetadata] class.
library dogma_codegen.src.metadata.class_metadata;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'metadata.dart';
import 'type_metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Contains metadata for a class.
class ClassMetadata extends Metadata {
  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// The parent class.
  final ClassMetadata superclass;
  /// The classes this class implements.
  final List<ClassMetadata> implements;
  /// The type arguments for the class.
  ///
  /// If the values contain [ClassMetadata] then the class is not defined as a
  /// generic. However if they contain [TypeMetadata] then the class is
  /// defined as generic.
  final List<Metadata> typeArguments;

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
               {this.superclass,
                this.implements: const [],
                this.typeArguments: const[]})
      : super(name);
}
