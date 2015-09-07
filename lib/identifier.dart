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

/// Regular expression for camel case.
final RegExp _camelCaseRegExp = new RegExp(r'^[a-z][A-Za-z\d]*$');
/// Regular expression for pascal case.
final RegExp _pascalCaseRegExp = new RegExp(r'^[A-Z][A-Za-z\d]*$');
/// Regular expression for snake case.
final RegExp _snakeCaseRegExp = new RegExp(r'^[a-z]+[a-z\d]*(?:_[a-z\d]+)*$');

/// Determines whether a [name] is in pascal case.
bool isCamelCase(String name)
    => _camelCaseRegExp.hasMatch(name);

/// Converts a [name] to camel case.
///
/// Attempts to determine the [name]'s current case and then picks the correct
/// function to call to perform the conversion. If the case of [name] is
/// already known then call the appropriate function as this won't attempt to
/// determine the casing.
String camelCase(String name) {
  if (isCamelCase(name)) {
    return name;
  } else if (isPascalCase(name)) {
    return pascalToCamelCase(name);
  } else {
    return snakeToCamelCase(name);
  }
}

/// Converts a list of [words] to camel case.
String camelCaseFromWords(List<String> words) {
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

/// Converts a camel case [name] to pascal case.
///
/// Assumes that [name] is in camel case.
String camelToPascalCase(String name)
    => name[0].toUpperCase() + name.substring(1);

/// Converts a camel case [name] to snake case.
///
/// Assumes that [name] is in camel case.
String camelToSnakeCase(String name)
    => snakeCaseFromWords(_pascalAndCamelToWords(name));

/// Determines whether a [name] is in pascal case.
bool isPascalCase(String name)
    => _pascalCaseRegExp.hasMatch(name);

/// Converts a [name] to pascal case.
///
/// Attempts to determine the [name]'s current case and then picks the correct
/// function to call to perform the conversion. If the case of [name] is
/// already known then call the appropriate function as this won't attempt to
/// determine the casing.
String pascalCase(String name) {
  if (isPascalCase(name)) {
    return name;
  } else if (isCamelCase(name)) {
    return camelToPascalCase(name);
  } else {
    return snakeToPascalCase(name);
  }
}

/// Converts a list of [words] to pascal case.
String pascalCaseFromWords(List<String> words) {
  var buffer = new StringBuffer();

  for (var word in words) {
    buffer.write(word[0].toUpperCase());
    buffer.write(word.substring(1));
  }

  return buffer.toString();
}

/// Converts a pascal case [name] to camel case.
///
/// Assumes that [name] is in pascal case.
String pascalToCamelCase(String name)
    => name[0].toLowerCase() + name.substring(1);

/// Converts a pascal case [name] to snake case.
///
/// Assumes that [name] is in pascal case.
String pascalToSnakeCase(String name)
    => snakeCaseFromWords(_pascalAndCamelToWords(name));

/// Determines whether a [name] is in snake case.
bool isSnakeCase(String name)
    => _snakeCaseRegExp.hasMatch(name);

/// Converts a [name] to snake case.
///
/// Attempts to determine the [name]'s current case and then picks the correct
/// function to call to perform the conversion. If the case of [name] is
/// already known then call the appropriate function as this won't attempt to
/// determine the casing.
String snakeCase(String name) {
  return isSnakeCase(name)
    ? name
    : snakeCaseFromWords(_pascalAndCamelToWords(name));
}

/// Converts a list of [words] to snake case.
String snakeCaseFromWords(List<String> words) {
  var buffer = new StringBuffer();
  var wordCount = words.length;

  buffer.write(words[0].toLowerCase());

  for (var i = 1; i < wordCount; ++i) {
    buffer.write('_');
    buffer.write(words[i].toLowerCase());
  }

  return buffer.toString();
}

/// Converts a snake case [name] to pascal case.
///
/// Assumes that [name] is actually in snake case.
String snakeToPascalCase(String name)
    => pascalCaseFromWords(name.split('_'));

/// Converts snake case to camel case.
///
/// Assumes that [name] is actually in snake case.
String snakeToCamelCase(String name)
    => camelCaseFromWords(name.split('_'));

/// Uses a regular expression to split a Pascal or Camel case [name] into words.
///
/// Used the example from http://weblogs.asp.net/jongalloway//426087 to
/// accomplish this. Its a bit overkill but seems to do the job for both cases.
List<String> _pascalAndCamelToWords(String name) {
  var regExp = new RegExp('[A-Z]|[0-9]+');

  return name.replaceAllMapped(
      regExp,
      (match) => ' ${match.group(0)}'
  ).trim().split(' ');
}
