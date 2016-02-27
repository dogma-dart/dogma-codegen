// Copyright (c) 2015-2016 the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

// \TODO Remove this file after https://github.com/dart-lang/test/issues/36 is resolved.

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:test/test.dart';

import 'codegen.dart' as codegen;
import 'identifier_test.dart' as identifier_test;
import 'schema_test.dart' as schema_test;

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

void main() {
  group('Codegen tests', codegen.main);
  group('Identifier tests', identifier_test.main);
  group('Schema tests', schema_test.main);
}
