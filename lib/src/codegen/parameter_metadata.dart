// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains functions to write out class declarations.
library dogma_codegen.src.codegen.parameter_generator;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import '../../metadata.dart';

import 'argument_buffer.dart';
import 'builtin_generator.dart';
import 'type_generator.dart';

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
  argumentBuffer.writeAll(findRequiredParameters(parameters).map/*<String>*/(
      (parameter) => generateRequiredParameter(parameter, useThis)
  ));

  // Write optional parameters
  var optionalArguments = writeArgumentsToString(findOptionalParameters(parameters).map(
      (parameter) => generateOptionalParameter(parameter, useThis)
  ));

  if (optionalArguments.isNotEmpty) {
    argumentBuffer.write('[$optionalArguments]');
  }

  // Write named parameters
  var namedArguments = writeArgumentsToString(findNamedParameters(parameters).map(
      (parameter) => generateNamedParameter(parameter, useThis)
  ));

  if (namedArguments.isNotEmpty) {
    argumentBuffer.write('{$namedArguments}');
  }

  // Write out to the buffer
  buffer.write(argumentBuffer.toString());

  // Write the closing parenthesis
  buffer.write(')');
}

String generateParameter(ParameterMetadata parameter, {bool useThis: false}) {
  switch (parameter.parameterKind) {
    case ParameterKind.required:
      return generateRequiredParameter(parameter, useThis);
    case ParameterKind.optional:
      return generateOptionalParameter(parameter, useThis);
    case ParameterKind.named:
      return generateNamedParameter(parameter, useThis);
  }
}

String generateRequiredParameter(ParameterMetadata parameter, bool useThis) {
  var prefix = useThis
      ? 'this.'
      : generateType(parameter.type) + ' ';

  return '$prefix${parameter.name}';
}

String generateOptionalParameter(ParameterMetadata parameter, bool useThis)
    => '${generateRequiredParameter(parameter, useThis)}${_generateDefaultValue(parameter, '=')}';

String generateNamedParameter(ParameterMetadata parameter, bool useThis)
    => '${generateRequiredParameter(parameter, useThis)}${_generateDefaultValue(parameter, ':')}';

String _generateDefaultValue(ParameterMetadata parameter,
                             String separator) {
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
