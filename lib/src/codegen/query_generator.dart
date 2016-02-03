// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.src.codegen.query_generator;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import '../../metadata.dart';

import 'class_generator.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Name for the static final query which is used when no fields are present.
const String _classQuery = '_query';

/// Writes out the class definition for a query using the [metadata].
void generateQuery(QueryMetadata metadata, StringBuffer buffer) {
  // Write the class definition
  generateClassDeclaration(metadata, buffer);
  buffer.writeln(' {');

  // Get the fields
  var fields = metadata.fields;

  // Determine if any fields are present
  //
  // If no fields are present then a static query can be used rather than
  // generating the underlying query.
  if (fields.isEmpty) {
    buffer.writeln('static final $_classQuery = new Query(\'test\');');
    buffer.writeln('@override');
    buffer.writeln('Query get query => $_classQuery;');
  } else {

  }

  buffer.writeln('}');
}
