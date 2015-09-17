// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.src.codegen.builtin_generator;

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Generates source code for a string [value].
String generateString(String value) => '\'$value\'';
