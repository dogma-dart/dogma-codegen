// Copyright (c) 2016, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_source_analyzer/metadata.dart';
import 'package:meta/meta.dart';

import '../../codegen.dart';
import 'configurable.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Generates the header of a library.
abstract class LibraryHeaderGenerationStep implements Configurable {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The generated header.
  ///
  /// This is used to determine if a file was generated by Dogma Codegen.
  static const String _generated = '// Generated by Dogma Codegen. DO NOT MODIFY!';

  //---------------------------------------------------------------------
  // Protected methods
  //---------------------------------------------------------------------

  /// Writes the header for the given [metadata] into the [buffer].
  @protected
  void generateHeader(LibraryMetadata metadata, StringBuffer buffer) {
    // Write the generated header
    _writeGeneratedHeader(buffer);

    // Write the copyright if present
    var copyright = config.copyright;

    if (copyright.isNotEmpty) {
      buffer.writeln(copyright);
    }

    // Write the library declaration if requested or required
    if ((config.outputLibraryDirective) || (metadata.annotations.isNotEmpty)) {
      generateLibraryDeclaration(metadata, 'test', buffer);
    }

    // Write the imports
    for (var imported in metadata.imports) {
      generateUriReference(imported, metadata.uri, 'import', buffer);
    }

    // Write the exports
    for (var exported in metadata.exports) {
      generateUriReference(exported, metadata.uri, 'export', buffer);
    }
  }

  /// Writes the generated header into the [buffer].
  ///
  /// This announces that the file was generated by Dogma and contains the
  /// timestamp for the generation.
  static void _writeGeneratedHeader(StringBuffer buffer) {
    buffer.writeln(_generated);
    buffer.writeln('// Generated at ${new DateTime.now().toIso8601String()}\n');
  }
}
