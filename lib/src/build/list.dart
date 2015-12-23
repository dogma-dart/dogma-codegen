// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains helper functions for lists.
library dogma_codegen.src.build.list;

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Adds the [value] to the [list] if [value] is not null.
void addIfNotNull(List list, dynamic value) {
  if (value != null) {
    list.add(value);
  }
}
