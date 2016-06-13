// Copyright (c) 2015-2016 the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_source_analyzer/metadata.dart';
import 'package:dogma_source_analyzer/path.dart' as p;

import '../../identifier.dart';
import 'annotated_metadata.dart';
import 'annotation.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Generates the library declaration from the [metadata] into the [buffer].
void generateLibraryDeclaration(LibraryMetadata metadata,
                                String package,
                                StringBuffer buffer,
                               {List<AnnotationGenerator> annotationGenerators}) {
  generateAnnotatedMetadata(metadata, buffer, annotationGenerators);

  var name = metadata.name;

  if (name.isEmpty) {
    var uri = metadata.uri;

    // Should always be a file path
    assert(uri.scheme == 'file');

    var pathSegments = uri.pathSegments;

    pathSegments = p.split(p.relative(uri));

    if (pathSegments[0] == 'lib') {
      pathSegments = pathSegments.sublist(1);
    }

    name = snakeCase('${package}_${pathSegments.join('_')}');
  }

  buffer.writeln('library $name');
}
