// Copyright (c) 2015-2016 the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_source_analyzer/metadata.dart';
import 'package:dogma_source_analyzer/matcher.dart';

import 'argument_buffer.dart';
import 'builtin_generator.dart';
import 'type_metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

void generateParameters(List<ParameterMetadata> parameters,
                        StringBuffer buffer,
                       {bool useThis: false}) {
  // Write the opening parenthesis
  buffer.write('(');

  var argumentBuffer = new ArgumentBuffer();

  // Write the required parameters
  argumentBuffer.writeAll(
      parameters
          .where(requiredParameterMatch)
          .map/*<String>*/(
              (parameter) => generateRequiredParameter(parameter, useThis)
          )
  );

  // Write positional parameters
  var positionalArguments = writeArgumentsToString(
      parameters
          .where(positionalParameterMatch)
          .map/*<String>*/(
              (parameter) => generateRequiredParameter(parameter, useThis)
          )
  );

  if (positionalArguments.isNotEmpty) {
    argumentBuffer.write('[$positionalArguments]');
  }

  // Write named parameters
  var namedArguments = writeArgumentsToString(
      parameters
          .where(namedParameterMatch)
          .map/*<String>*/(
              (parameter) => generateRequiredParameter(parameter, useThis)
          )
  );

  if (namedArguments.isNotEmpty) {
    argumentBuffer.write('{$namedArguments}');
  }

  // Write out to the buffer
  buffer.write(argumentBuffer.toString());

  // Write the closing parenthesis
  buffer.write(')');
}

/// Generates the source code for a [parameter].
///
/// This will determine what type of parameter is present before generating
/// the code. If the type is known then the specific generator function should
/// be called instead.
///
/// If [useThis] is `true` then the value will be prefixed with `this`.
String generateParameter(ParameterMetadata parameter, {bool useThis: false}) {
  switch (parameter.parameterKind) {
    case ParameterKind.required:
      return generateRequiredParameter(parameter, useThis);
    case ParameterKind.positional:
      return generatePositionalParameter(parameter, useThis);
    case ParameterKind.named:
      return generateNamedParameter(parameter, useThis);
  }
}

/// Generates the source code for a required [parameter].
///
/// If [useThis] is `true` then the value will be prefixed with `this`.
String generateRequiredParameter(ParameterMetadata parameter, bool useThis) {
  var prefix = useThis
      ? 'this.'
      : generateType(parameter.type) + ' ';

  return '$prefix${parameter.name}';
}

/// Generates the source code for a positional [parameter].
///
/// If [useThis] is `true` then the value will be prefixed with `this`.
String generatePositionalParameter(ParameterMetadata parameter, bool useThis) =>
    '${generateRequiredParameter(parameter, useThis)}${_generateDefaultValue(parameter, '=')}';

/// Generates the source code for a named [parameter].
///
/// If [useThis] is `true` then the value will be prefixed with `this`.
String generateNamedParameter(ParameterMetadata parameter, bool useThis) =>
    '${generateRequiredParameter(parameter, useThis)}${_generateDefaultValue(parameter, ':')}';

/// Generates the default value for the [parameter].
///
/// A [separator] can be specified to handle the syntax difference between
/// positional and named parameters.
String _generateDefaultValue(ParameterMetadata parameter, String separator) {
  var defaultValue = parameter.defaultValue;

  return defaultValue != null
      ? '$separator${generateBuiltin(defaultValue, isConst: true)}'
      : '';
}

/// Generates the source code for a function/method call with the given
/// [arguments] into the [buffer].
///
/// The [namedArguments] value has a
void generateArguments(List<String> arguments,
                       StringBuffer buffer,
                      {Map<String, String> namedArguments}) {
  namedArguments ??= <String, String>{};

  // Write the opening parenthesis
  buffer.write('(');

  var argumentBuffer = new ArgumentBuffer();

  // Iterate over the arguments
  for (var argument in arguments) {
    argumentBuffer.write(argument);
  }

  // Iterate over the named arguments
  namedArguments.forEach((key, value) {
    argumentBuffer.write('$key:$value');
  });

  // Write the arguments
  buffer.write(argumentBuffer.toString());

  // Write the closing parenthesis
  buffer.write(')');
}
