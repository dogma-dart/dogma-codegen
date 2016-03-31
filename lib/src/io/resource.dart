// Copyright (c) 2015-2016, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:async';

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'file.dart';
import 'package.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Reads a resource at the given [uri].
///
/// Based on the scheme of the [uri] the function will pick the applicable
/// implementation for getting that type of resource.
///
/// This implementation currently supports the following schemes
/// * file
/// * package
Future<String> readResource(Uri uri) {
  if (uri.scheme == 'file') {
    return readFileResource(uri);
  } else if (uri.scheme == 'package') {
    return readPackageResource(uri);
  } else {
    throw new ArgumentError.value(uri, 'Resource is not a package or file');
  }
}

/// Writes the [contents] of a resource to the given [uri].
///
/// Based on the scheme of the [uri] the function will pick the applicable
/// implementation for getting that type of resource.
///
/// This implementation currently supports the following schemes
/// * file
Future<Null> writeResource(Uri uri, String contents) {
  if (uri.scheme == 'file') {
    return writeFileResource(uri, contents);
  } else {
    throw new ArgumentError.value(uri, 'Resource is not a file');
  }
}
