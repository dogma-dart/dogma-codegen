// Copyright (c) 2015-2016, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:meta/meta.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Generates the @protected annotation into the [buffer] if the [value] is
/// equal to [protected].
void generateProtectedAnnotation(dynamic value, StringBuffer buffer) {
  if (value == protected) {
    buffer.writeln('@protected');
  }
}
