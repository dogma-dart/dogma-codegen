// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

// \TODO Remove this file after https://github.com/dart-lang/test/issues/36 is resolved.

/// Runs all the tests to handle code coverage generation.
library dogma_codegen.test.all;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:test/test.dart';

import 'src/analyzer/analyzer_metadata_test.dart' as analyzer_metadata_test;

import 'src/build/built_libraries_test.dart' as built_libraries_test;

import 'src/codegen/argument_buffer_test.dart' as argument_buffer_test;
import 'src/codegen/builtin_generator_test.dart' as builtin_generator_test;
import 'src/codegen/comment_generator_test.dart' as comment_generator_test;
import 'src/codegen/parameter_generator_test.dart' as parameter_generator_test;
import 'src/codegen/serialize_annotation_generator_test.dart' as serialize_annotation_generator_test;

import 'identifier_test.dart' as identifier_test;

import 'src/metadata/converter_function_metadata_test.dart' as converter_function_metadata_test;
import 'src/metadata/converter_metadata_test.dart' as converter_metadata_test;
import 'src/metadata/enum_metadata_test.dart' as enum_metadata_test;
import 'src/metadata/field_metadata_test.dart' as field_metadata_test;
import 'src/metadata/model_metadata_test.dart' as model_metadata_test;
import 'src/metadata/type_metadata_test.dart' as type_metadata_test;

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

void main() {
  group('Analyzer tests', analyzer_metadata_test.main);
  group('Build tests', built_libraries_test.main);
  group('Codegen tests', () {
    group('ArgumentBuffer', argument_buffer_test.main);
    group('Builtin', builtin_generator_test.main);
    group('Comments', comment_generator_test.main);
    group('Parameter', parameter_generator_test.main);
    group('Serialize', serialize_annotation_generator_test.main);
  });
  group('Identifier tests', identifier_test.main);
  group('Metadata tests', () {
    group('ConverterMetadata', converter_metadata_test.main);
    group('EnumMetadata', enum_metadata_test.main);
    group('FieldMetadata', field_metadata_test.main);
    group('ConverterFunctionMetadata', converter_function_metadata_test.main);
    group('ModelMetadata', model_metadata_test.main);
    group('TypeMetadata', type_metadata_test.main);
  });
}
