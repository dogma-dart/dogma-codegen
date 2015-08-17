// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Functions for handling identifiers.
///
/// Contains functions to deal with naming of identifiers and modifying their
/// casing.
///
/// * Pascal case - AnIdentifierName (Corresponds to class names)
/// * Camel case - anIdentifierName (Corresponds to fields/properties/functions names)
/// * Snake case - an_identifier_name (Corresponds to library and file names)
library dogma_codegen.identifier;

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Converts a [name] to camel case.
///
/// Attempts to determine the [name]'s current case and then picks the correct
/// function to call to perform the conversion. If the case of [name] is
/// already known then call the appropriate function as this won't attempt to
/// determine the casing.
String camelCase(String name) {

}

/// Converts a camel case [name] to pascal case.
///
/// Assumes that [name] is in camel case.
String camelToPascalCase(String name)
    => name[0].toUpperCase() + name.substring(1);

/// Converts a camel case [name] to snake case.
///
/// Assumes that [name] is in camel case.
String camelToSnakeCase(String name) {

}

/// Converts a [name] to pascal case.
///
/// Attempts to determine the [name]'s current case and then picks the correct
/// function to call to perform the conversion. If the case of [name] is
/// already known then call the appropriate function as this won't attempt to
/// determine the casing.
String pascalCase(String name) {

}

/// Converts a pascal case [name] to camel case.
///
/// Assumes that [name] is in pascal case.
String pascalToCamelCase(String name)
    => name[0].toLowerCase() + name.substring(1);

/// Converts a pascal case [name] to snake case.
///
/// Assumes that [name] is in pascal case.
String pascalToSnakeCase(String name) {

}

/// Converts a [name] to snake case.
///
/// Attempts to determine the [name]'s current case and then picks the correct
/// function to call to perform the conversion. If the case of [name] is
/// already known then call the appropriate function as this won't attempt to
/// determine the casing.
String snakeCase(String name) {

}

/// Converts a snake case [name] to pascal case.
///
/// Assumes that [name] is actually in snake case.
String snakeToPascalCase(String name)
    => _pascalCase(name.split('_'));

/// Converts snake case to camel case.
///
/// Assumes that [name] is actually in snake case.
String snakeToCamelCase(String name)
    => _camelCase(name.split('_'));

/// Writes out a list of [words] to camel case.
String _camelCase(List<String> words) {
  var buffer = new StringBuffer();
  var wordCount = words.length;

  buffer.write(words[0].toLowerCase());

  for (var i = 1; i < wordCount; ++i) {
    var word = words[i];

    buffer.write(word[0].toUpperCase());
    buffer.write(word.substring(1));
  }

  return buffer.toString();
}

/// Writes out a list of [words] to pascal case.
String _pascalCase(List<String> words) {
  var buffer = new StringBuffer();

  for (var word in words) {
    buffer.write(word[0].toUpperCase());
    buffer.write(word.substring(1));
  }

  return buffer.toString();
}

/// Writes out a list of [words] to snake case.
String _snakeCase(List<String> words) {
  var buffer = new StringBuffer();
  var wordCount = words.length;

  buffer.write(words[0].toLowerCase());

  for (var i = 1; i < wordCount; ++i) {
    buffer.write('_');
    buffer.write(words[i].toLowerCase());
  }

  return buffer.toString();
}
