// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.test.src.analyzer.identifier_test;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/identifier.dart';
import 'package:test/test.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Test entry point.
void main() {
  test('isCamelCase', () {
    expect(isCamelCase('camelCaseString'), true);
    expect(isCamelCase('PascalCaseString'), false);
    expect(isCamelCase('snake_case_string'), false);
    expect(isCamelCase('spinal-case-string'), false);

    expect(isCamelCase('almostCamelCase_00'), false);
    expect(isCamelCase('matchWithDI00'), true);
  });

  test('isPascalCase', () {
    expect(isPascalCase('camelCaseString'), false);
    expect(isPascalCase('PascalCaseString'), true);
    expect(isPascalCase('snake_case_string'), false);
    expect(isPascalCase('spinal-case-string'), false);

    expect(isPascalCase('almostPascalCase_00'), false);
    expect(isPascalCase('MatchWithDI00'), true);
  });

  test('isSnakeCase', () {
    expect(isSnakeCase('camelCaseString'), false);
    expect(isSnakeCase('PascalCaseString'), false);
    expect(isSnakeCase('snake_case_string'), true);
    expect(isSnakeCase('spinal-case-string'), false);

    expect(isSnakeCase('almost_Snake_case_00'), false);
    expect(isSnakeCase('match_with_di_00'), true);
  });

  test('isSpinalCase', () {
    expect(isSpinalCase('camelCaseString'), false);
    expect(isSpinalCase('PascalCaseString'), false);
    expect(isSpinalCase('snake_case_string'), false);
    expect(isSpinalCase('spinal-case-string'), true);

    expect(isSpinalCase('almost-Spinal-case-00'), false);
    expect(isSpinalCase('match-with-di-00'), true);
  });

  var camelCaseWords = ['anIdentifierString', 'withDigits01'];
  var pascalCaseWords = ['AnIdentifierString', 'WithDigits01'];
  var snakeCaseWords = ['an_identifier_string', 'with_digits_01'];
  var spinalCaseWords = ['an-identifier-string', 'with-digits-01'];

  test('camelCase conversion', () {
    for (var i = 0; i < camelCaseWords.length; ++i) {
      var camel = camelCaseWords[i];
      var pascal = pascalCaseWords[i];
      var snake = snakeCaseWords[i];
      var spinal = spinalCaseWords[i];

      expect(camelCase(camel), camel);
      expect(camelCase(pascal), camel);
      expect(camelCase(snake), camel);
      expect(camelCase(spinal), camel);
      expect(pascalToCamelCase(pascal), camel);
      expect(snakeToCamelCase(snake), camel);
      expect(spinalToCamelCase(spinal), camel);
    }
  });

  test('pascalCase conversion', () {
    for (var i = 0; i < camelCaseWords.length; ++i) {
      var camel = camelCaseWords[i];
      var pascal = pascalCaseWords[i];
      var snake = snakeCaseWords[i];
      var spinal = spinalCaseWords[i];

      expect(pascalCase(camel), pascal);
      expect(pascalCase(pascal), pascal);
      expect(pascalCase(snake), pascal);
      expect(pascalCase(spinal), pascal);
      expect(camelToPascalCase(camel), pascal);
      expect(snakeToPascalCase(snake), pascal);
      expect(spinalToPascalCase(spinal), pascal);
    }
  });

  test('snakeCase conversion', () {
    for (var i = 0; i < camelCaseWords.length; ++i) {
      var camel = camelCaseWords[i];
      var pascal = pascalCaseWords[i];
      var snake = snakeCaseWords[i];
      var spinal = spinalCaseWords[i];

      expect(snakeCase(camel), snake);
      expect(snakeCase(pascal), snake);
      expect(snakeCase(snake), snake);
      expect(snakeCase(spinal), snake);
      expect(camelToSnakeCase(camel), snake);
      expect(pascalToSnakeCase(pascal), snake);
      expect(spinalToSnakeCase(spinal), snake);
    }
  });

  test('spinalCase conversion', () {
    for (var i = 0; i < camelCaseWords.length; ++i) {
      var camel = camelCaseWords[i];
      var pascal = pascalCaseWords[i];
      var snake = snakeCaseWords[i];
      var spinal = spinalCaseWords[i];

      expect(spinalCase(camel), spinal);
      expect(spinalCase(pascal), spinal);
      expect(spinalCase(snake), spinal);
      expect(spinalCase(spinal), spinal);
      expect(camelToSpinalCase(camel), spinal);
      expect(pascalToSpinalCase(pascal), spinal);
      expect(snakeToSpinalCase(snake), spinal);
    }
  });
}
