// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains source code generators for built in types.
library dogma_codegen.src.codegen.builtin_generator;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'argument_buffer.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Generates source code for a built in [value].
///
/// The [lineBreak] value specifies whether values should go onto the new line.
/// This is only applicable when value is a List or Map.
String generateBuiltin(dynamic value, {bool lineBreak: false, bool isConst: false}) {
  if (value is String) {
    return generateString(value);
  } else if (value is List) {
    return generateList(value, lineBreak, isConst);
  } else if (value is Map) {
    return generateMap(value, lineBreak, isConst);
  } else {
    return value.toString();
  }
}

/// Generates source code for a string [value].
String generateString(String value) => '\'$value\'';

/// Generates source code for list [values].
///
/// The [lineBreak] value specifies whether values should go onto the new line.
String generateList(List values, bool lineBreak, bool isConst) {
  var buffer = _buffer(lineBreak);

  for (var value in values) {
    buffer.write(generateBuiltin(value, lineBreak: lineBreak, isConst: isConst));
  }

  var separator = _separator(lineBreak);

  return '${_constPrefix(isConst)}[$separator${buffer.toString()}$separator]';
}

/// Generates source code for map [values].
///
/// The [lineBreak] value specifies whether values should go onto the new line.
String generateMap(Map values, bool lineBreak, bool isConst) {
  var buffer = _buffer(lineBreak);

  values.forEach((key, value) {
    var keyBuiltin = generateBuiltin(key, lineBreak: lineBreak, isConst: isConst);
    var valueBuiltin = generateBuiltin(value, lineBreak: lineBreak, isConst: isConst);

    buffer.write('$keyBuiltin:$valueBuiltin');
  });

  var separator = _separator(lineBreak);

  return '${_constPrefix(isConst)}{$separator${buffer.toString()}$separator}';
}

/// Creates an [ArgumentBuffer] based on whether [lineBreak]s are requested.
ArgumentBuffer _buffer(bool lineBreak) =>
    lineBreak ? new ArgumentBuffer.lineBreak() : new ArgumentBuffer();

/// Gets the separator for a [lineBreak].
String _separator(bool lineBreak) => lineBreak ? '\n' : '';

/// Gets the prefix for a const value.
String _constPrefix(bool isConst) => isConst ? 'const' : '';
