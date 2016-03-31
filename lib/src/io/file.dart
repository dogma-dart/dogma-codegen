// Copyright (c) 2015-2016, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:async';
import 'dart:io';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Reads a file resource at the [uri].
///
/// This assumes that the [uri] is a file path.
Future<String> readFileResource(Uri uri) =>
    new File(uri.toFilePath()).readAsString();

/// Writes the [contents] of a file resource at the [uri].
///
/// This assumes that the [uri] is a file path].
Future<Null> writeFileResource(Uri uri, String contents) async {
  var file = new File(uri.toFilePath());

  await file.writeAsString(contents);
}
