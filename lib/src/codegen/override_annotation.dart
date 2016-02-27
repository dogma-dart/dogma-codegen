// Copyright (c) 2015-2016, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Generates the @override annotation into the [buffer] if the [value] is
/// equal to [override].
void generateOverrideAnnotation(dynamic value, StringBuffer buffer) {
  if (value == override) {
    buffer.writeln('@override');
  }
}
