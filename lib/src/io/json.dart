// Copyright (c) 2015-2016, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:async';
import 'dart:convert';

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'resource.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Reads the contents of a JSON resource at the [uri].
Future<dynamic /*=T*/> readJson/*<T>*/(Uri uri) async {
  var contents = await readResource(uri);

  return JSON.decode(contents) as dynamic /*=T*/;
}

/// Writes the contents of a JSON resource to the [uri].
Future<Null> writeJson/*<T>*/(Uri uri, /*=T*/ contents) {
  var encoded = JSON.encode(contents);

  return writeResource(uri, encoded);
}
