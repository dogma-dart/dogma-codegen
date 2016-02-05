// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Exposes functionality for handling the inline loading and referencing of
/// a schema.
///
/// Formats such as JSON Schema allow references to data. This data could be
/// available in the loaded data or could require a call out to load an
/// additional file.
library dogma_codegen.schema;

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:async';

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

// \TODO Use local path.dart?
import 'package:path/path.dart' as p;

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Identifier for a root scope.
///
/// When referencing map data the rootScope identifies the values within the
///
const String rootScope = '#';
/// Identifier for holding the root path within the schema.
///
/// The root path is used to determine where additional schemas are located.
const String _rootPath = '_rootPath';

/// Function to load a reference at [path] determined by the [getReference]
/// function.
///
/// The [path] passed in will be computed based on its path relative to the
/// root schema.
typedef Future<dynamic> LoadReference(String path);

/// Creates the root schema from the [value].
///
/// For schemas that split their data into multiple files a [reference] can be
/// specified which will be used to get the actual path when dealing with
/// references. For this case the [reference] should be a path that encompasses
/// all the potential references.
///
/// As an example if you had the following files.
///
///     + schema
///       + common
///         error.yml
///       + spec
///         pet.yml
///         new_pet.yml
///         swagger.yml
///
/// Then when creating the root schema as swagger.yml the value passed to
/// reference should be `'schema/common/swagger.yml'`. The ensures that
/// relative paths can be used successfully.
///
/// The returned map will contain a reference to the value at the given
/// [reference]. If none is provided then it will just be set to the root and
/// can be accessed in [getReference] by passing the empty string to the
/// reference.
Map createRootSchema(Map value, [String reference = '']) {
  var schema = {};

  _setReference(schema, reference, value);

  return schema;
}

/// Retrieves the value from the [schema] at the given [reference].
///
/// If the referenced value is not already present in the [schema] data then
/// the [loadReference] function will be used to retrieve it. The path to the
/// reference is determined by the [currentScope].
///
/// If it can still not be found then a [FormatException] will be thrown.
Future<dynamic /*=T*/> getReference/*<T>*/(Map schema,
                                           String reference,
                                           LoadReference loadReference,
                                          [String currentScope = '']) async {
  // See if there is a # in the reference
  var indexOfRootScope = reference.lastIndexOf(rootScope);
  var beforeRootScope;
  var afterRootScope;

  // Split the reference into two parts
  if (indexOfRootScope == -1) {
    beforeRootScope = reference;
    afterRootScope = '#';
  } else {
    beforeRootScope = reference.substring(0, indexOfRootScope);
    afterRootScope = p.posix.join(rootScope, reference.substring(indexOfRootScope + 1));
  }

  // Join the path
  var path = p.posix.normalize(p.posix.join(currentScope, beforeRootScope));

  if (path == '.') {
    path = '';
  }

  // Attempt to load the value
  var value = _findValueFromPath(schema, path);

  if (value == null) {
    value = await loadReference(path);

    // Add the child schema
    value = _setReference(schema, path, value);
  }

  value = _findValueFromPath(value, afterRootScope);

  if (value == null) {
    throw new FormatException('Cannot find $reference');
  }

  return value as dynamic /*=T*/;
}

/// Adds the [value] to the [schema] at the [reference] location.
Map _setReference(Map schema, String reference, Map value) {
  var search = schema;

  for (var key in p.posix.split(reference)) {
    if (!search.containsKey(key)) {
      search[key] = {};
    }

    search = search[key];
  }

  search[rootScope] = value;

  return search;
}

/// Walks the [schema] map using the [path] as a delimiter.
Map _findValueFromPath(Map schema, String path) {
  var value = schema;

  for (var key in p.posix.split(path)) {
    value = value[key];

    if (value == null) {
      break;
    }
  }

  return value;
}
