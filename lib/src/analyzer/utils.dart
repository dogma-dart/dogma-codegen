// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Utility functions for analysis of a project.
library dogma_codegen.src.analyzer.utils;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:analyzer/src/generated/element.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Finds all the values of an enumeration from the [element].
List<ConstFieldElementImpl> enumValues(ClassElement element) {
  var name = element.name;

  return new List<ConstFieldElementImpl>.from(
      element.fields.where((field) => field.type.name == name));
}
