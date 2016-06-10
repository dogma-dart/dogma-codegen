// Copyright (c) 2015-2016, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_source_analyzer/metadata.dart';
import 'package:dogma_source_analyzer/path.dart' as p;

import 'argument_buffer.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Generates a uri reference from the [metadata] into the [buffer].
///
/// The [directive], either import or export, is relative to the value of
/// [from] when a file uri is encountered.
void generateUriReference(UriReferencedMetadata metadata,
                          Uri from,
                          String directive,
                          StringBuffer buffer) {
  buffer.write('$directive ');

  // Get the path to the reference
  var toUri = metadata.library.uri;
  var path = toUri.scheme != 'file'
      ? toUri.toString()
      : p.relative(metadata.library.uri, from: from);

  buffer.write('\'$path\'');

  // Write out the prefix if required
  var prefix = metadata.prefix;

  if (prefix.isNotEmpty) {
    buffer.write(' as $prefix');
  }

  // Write out show
  var shownNames = metadata.shownNames;

  if (shownNames.isNotEmpty) {
    buffer.write(' show ');
    writeArgumentsToBuffer(shownNames, buffer);
  }

  // Write out hide
  var hiddenNames = metadata.hiddenNames;

  if (hiddenNames.isNotEmpty) {
    buffer.write(' hide ');
    writeArgumentsToBuffer(hiddenNames, buffer);
  }

  buffer.writeln(';');
}
