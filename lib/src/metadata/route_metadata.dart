// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.src.metadata.route_metadata;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'metadata.dart';

import 'package:path/path.dart';
import 'package:dogma_codegen/identifier.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

class RouteMetadata extends Metadata {
  final String path;

  factory RouteMetadata(String path) {
    // Remove the {} from the name as this can't be used in an identifier
    var withoutBrackets = path.replaceAll(new RegExp('[{}]'), '');

    // Split into words using a posix path and remove leading /
    var words = posix.split(posix.withoutExtension(withoutBrackets)).sublist(1);

    // Create the name
    var name = camelCaseFromWords(words);

    return new RouteMetadata._internal(name, path);
  }

  RouteMetadata._internal(String name, this.path)
      : super(name);
}
