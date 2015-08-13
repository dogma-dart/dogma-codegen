// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Functions for handling uri paths.
library dogma_codegen.path;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:path/path.dart' as path;

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// The current path running the application.
///
/// Parses the current path using the path based on the environment and then
/// converts to a posix style. This is done to ensure that paths are handled
/// consistently as all path operations will be done using the posix
/// implementation held in path.
final _currentPath = path.toUri(path.current).toFilePath(windows: false);

Uri join(dynamic value, {dynamic base}) {
  base ??= _currentPath;

  if (base is Uri) {
    base = base.toFilePath(windows: false);
  }

  var joined = path.posix.join(base, value);

  return path.posix.toUri(joined);
}

String relative(dynamic value, {dynamic from}) {
  from ??= _currentPath;

  // Turn into a file path
  from = _filePath(from);
  value = _filePath(value);

  // Convert from into the dirname
  from = _isDirectory(from) ? from : path.posix.dirname(from);

  return path.posix.relative(value, from: from);
}

String dirname(dynamic value) {
  value = _filePath(value);

  return path.posix.dirname(value);
}

Uri libraryPath(String value) {
  // Split based on the .
  var split = value.split('.').sublist(1);

  var base = _isInLib(split[0])
      ? path.posix.join(_currentPath, 'lib')
      : _currentPath;

  // Add .dart to the last value
  split[split.length - 1] += '.dart';

  return path.posix.toUri(path.posix.join(base, path.posix.joinAll(split)));
}

/// Converts the [value] into a file path.
String _filePath(dynamic value) {
  return value is Uri ? value.toFilePath(windows: false) : value;
}

bool _isInLib(String value) {
  return
      value != 'example' &&
      value != 'test' &&
      value != 'bin' &&
      value != 'tool';
}

bool _isDirectory(String value)
    => path.posix.withoutExtension(value) == value;