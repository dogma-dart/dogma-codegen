// Copyright (c) 2015-2016 the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

// \TODO Remove this file after https://github.com/dart-lang/test/issues/36 is resolved.

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:test/test.dart';

import 'src/codegen/argument_buffer_test.dart' as argument_buffer_test;
import 'src/codegen/builtin_generator_test.dart' as builtin_generator_test;
import 'src/codegen/comments_test.dart' as comments_test;
import 'src/codegen/deprecated_annotation_test.dart' as deprecated_annotation_test;
import 'src/codegen/override_annotation_test.dart' as override_annotation_test;
import 'src/codegen/parameter_metadata_test.dart' as parameter_metadata_test;
import 'src/codegen/protected_annotation_test.dart' as protected_annotation_test;

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

void main() {
  group('ArgumentBuffer', argument_buffer_test.main);
  group('Builtin', builtin_generator_test.main);
  group('Comments', comments_test.main);
  group('Deprecated annotation', deprecated_annotation_test.main);
  group('Override annotation', override_annotation_test.main);
  group('ParameterMetadata', parameter_metadata_test.main);
  group('Protected annotation', protected_annotation_test.main);
}
