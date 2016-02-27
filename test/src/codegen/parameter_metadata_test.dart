// Copyright (c) 2015-2016 the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_source_analyzer/metadata.dart';
import 'package:test/test.dart';

import 'package:dogma_codegen/codegen.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

const String _value = 'value';
const String _typeName = 'String';
final TypeMetadata _type = new TypeMetadata(_typeName);
const String _expectedRequired = '$_typeName $_value';
const String _expectedThisRequired = 'this.$_value';
const String _defaultsTo = 'defaultsTo';

/// Test entry point.
void main() {
  test('required', () {
    var parameter = new ParameterMetadata(_value, _type);

    expect(generateParameter(parameter), _expectedRequired);
    expect(generateRequiredParameter(parameter, false), _expectedRequired);
    expect(generateParameter(parameter, useThis: true), _expectedThisRequired);
    expect(generateRequiredParameter(parameter, true), _expectedThisRequired);
  });
  test('optional', () {
    var parameter = new ParameterMetadata(_value, _type, parameterKind: ParameterKind.positional);

    expect(generateParameter(parameter), _expectedRequired);
    expect(generatePositionalParameter(parameter, false), _expectedRequired);
    expect(generateParameter(parameter, useThis: true), _expectedThisRequired);
    expect(generatePositionalParameter(parameter, true), _expectedThisRequired);
  });
  test('optional with default', () {
    var parameter = new ParameterMetadata(_value, _type, parameterKind: ParameterKind.positional, defaultValue: _defaultsTo);
    var expected = '$_expectedRequired=\'$_defaultsTo\'';
    var expectedThis = '$_expectedThisRequired=\'defaultsTo\'';

    expect(generateParameter(parameter), expected);
    expect(generatePositionalParameter(parameter, false), expected);
    expect(generateParameter(parameter, useThis: true), expectedThis);
    expect(generatePositionalParameter(parameter, true), expectedThis);
  });
  test('named', () {
    var parameter = new ParameterMetadata(_value, _type, parameterKind: ParameterKind.named);

    expect(generateParameter(parameter), _expectedRequired);
    expect(generateNamedParameter(parameter, false), _expectedRequired);
    expect(generateParameter(parameter, useThis: true), _expectedThisRequired);
    expect(generateNamedParameter(parameter, true), _expectedThisRequired);
  });
  test('named with default', () {
    var parameter = new ParameterMetadata(_value, _type, parameterKind: ParameterKind.named, defaultValue: _defaultsTo);
    var expected = '$_expectedRequired:\'$_defaultsTo\'';
    var expectedThis = '$_expectedThisRequired:\'defaultsTo\'';

    expect(generateParameter(parameter), expected);
    expect(generateNamedParameter(parameter, false), expected);
    expect(generateParameter(parameter, useThis: true), expectedThis);
    expect(generateNamedParameter(parameter, true), expectedThis);
  });
  test('parameters', () {
    var r0 = new ParameterMetadata('r0', _type);
    var r1 = new ParameterMetadata('r1', _type);
    var o0 = new ParameterMetadata('o0', _type, parameterKind: ParameterKind.positional);
    var o1 = new ParameterMetadata('o1', _type, parameterKind: ParameterKind.positional);
    var n0 = new ParameterMetadata('n0', _type, parameterKind: ParameterKind.named);
    var n1 = new ParameterMetadata('n1', _type, parameterKind: ParameterKind.named);

    var buffer = new StringBuffer();
    var required = 'String r0,String r1';
    var optional = '[String o0,String o1]';
    var named = '{String n0,String n1}';

    // Just required
    generateParameters([ r0, r1 ], buffer);
    expect(buffer.toString(), '($required)');

    // Just optional
    buffer.clear();
    generateParameters([ o0, o1], buffer);
    expect(buffer.toString(), '($optional)');

    // Just named
    buffer.clear();
    generateParameters([ n0, n1 ], buffer);
    expect(buffer.toString(), '($named)');

    // Required + optional
    buffer.clear();
    generateParameters([ r0, r1, o0, o1], buffer);
    expect(buffer.toString(), '($required,$optional)');

    // Required + named
    buffer.clear();
    generateParameters([ r0, r1, n0, n1], buffer);
    expect(buffer.toString(), '($required,$named)');
  });
  test('arguments', () {
    var buffer = new StringBuffer();
    var argumentList = <String>['a', 'b', 'c'];
    var expectedList = 'a,b,c';
    var namedArguments = <String, String>{'d':'d1', 'e': 'e1'};
    var expectedNamed = 'd:d1,e:e1';

    // No arguments
    generateArguments([], buffer);
    expect(buffer.toString(), '()');

    // List of arguments
    buffer.clear();
    generateArguments(argumentList, buffer);
    expect(buffer.toString(), '($expectedList)');

    // Named arguments
    buffer.clear();
    generateArguments([], buffer, namedArguments: namedArguments);
    expect(buffer.toString(), '($expectedNamed)');

    // List + named
    buffer.clear();
    generateArguments(argumentList, buffer, namedArguments: namedArguments);
    expect(buffer.toString(), '($expectedList,$expectedNamed)');
  });
}
