// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.src.codegen.utils;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';
import 'package:path/path.dart' show posix;

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Generates a string representing the type [metadata].
String typeName(TypeMetadata metadata) {
  var buffer = new StringBuffer();
  var arguments = metadata.arguments;
  var argumentCount = arguments.length;
  buffer.write(metadata.name);

  if (argumentCount > 0) {
    buffer.write('<');

    buffer.write(typeName(arguments[0]));
    for (var i = 1; i < argumentCount; ++i) {
      buffer.write(',');
      buffer.write(typeName(arguments[i]));
    }

    buffer.write('>');
  }

  return buffer.toString();
}

/// Converts a string [value] into pascal case, e.g. PascalCase.
///
/// The '_' character is used to split the string into words.
String pascalCase(String value) {
  var buffer = new StringBuffer();
  var words = value.split('_');

  for (var word in words) {
    buffer.write(word[0].toUpperCase());
    buffer.write(word.substring(1));
  }

  return buffer.toString();
}

/// Converts a string [value] into came case, e.g. camelCase.
///
/// The '_' character is used to split the string into words.
String camelCase(String value) {
  var buffer = new StringBuffer();
  var words = value.split('_');
  var splitCount = words.length;

  var word = words[0];
  var substring = word.substring(1);

  buffer.write(word[0].toLowerCase());
  buffer.write(word.substring(1));

  for (var i = 1; i < splitCount; ++i) {
    word = words[i];

    buffer.write(word[0].toUpperCase());
    buffer.write(word.substring(1));
  }

  return buffer.toString();
}

String snakeCase(String value) {
  var buffer = new StringBuffer();
  var regExp = new RegExp('[A-z][a-z]+');
  var split = regExp.allMatches(value).map((match) => match.group(0)).toList();
  var splitCount = split.length;

  buffer.write(split[0].toLowerCase());

  for (var i = 1; i < splitCount; ++i) {
    buffer.write('_');
    buffer.write(split[i].toLowerCase());
  }

  return buffer.toString();
}

/// Determines the name of a library in the [package] with the given [path].
String libraryName(String package, String path) {
  var buffer = new StringBuffer();
  var split = posix.split(posix.withoutExtension(path)).sublist(1);

  buffer.write(package);

  for (var value in split) {
    buffer.write('.');
    buffer.write(value);
  }

  return buffer.toString();
}

String libraryPath(String name) {
  // Split based on the '.' and remove the package name
  var split = name.split('.').sublist(1);

  // Append .dart to the last value in the name
  var lastIndex = split.length - 1;
  var last = split[lastIndex];
  split[lastIndex] = last + '.dart';

  return posix.join('lib', posix.joinAll(split));
}
