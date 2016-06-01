// Copyright (c) 2015-2016 the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Creates a new scope within the [buffer].
///
/// If [useArrow] is true the arrow function is used; otherwise an opening
/// brace is added.
void openScope(StringBuffer buffer, [bool useArrow = false]) {
  var write = useArrow ? '=>' : '{\n';

  buffer.write(write);
}

/// Removes a scope within the [buffer].
///
/// If [useArrow] is true then a closing brace will not be added.
void closeScope(StringBuffer buffer, [bool useArrow = false]) {
  if (!useArrow) {
    buffer.writeln('}');
  } else {
    buffer.writeln(';');
  }
}
