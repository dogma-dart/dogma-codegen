// Copyright (c) 2015-2016 the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_source_analyzer/metadata.dart';

import 'annotated_metadata.dart';
import 'annotation.dart';
import 'parameter_metadata.dart';
import 'scope.dart';
import 'type_metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Definition of a function that generates the source code for a function.
///
/// The source code generated is written into the [buffer].
typedef void FunctionGenerator(FunctionMetadata function, StringBuffer buffer);

/// Creates the declaration for the function [metadata] into the [buffer].
void generateFunctionDeclaration(FunctionMetadata metadata, StringBuffer buffer) {
  buffer.write(generateType(metadata.returnType));
  buffer.write(' ');
  buffer.write(metadata.name);

  generateParameters(metadata.parameters, buffer);
}

/// Creates the definition for the function [metadata] into the [buffer] using
/// the [generator] for the body.
void generateFunctionDefinition(FunctionMetadata metadata,
                                StringBuffer buffer,
                                FunctionGenerator generator,
                               {List<AnnotationGenerator> annotationGenerators,
                                bool useArrow: false}) {
  annotationGenerators ??= <AnnotationGenerator>[];

  // Write out metadata
  generateAnnotatedMetadata(metadata, buffer, annotationGenerators);

  // Write the function declaration
  generateFunctionDeclaration(metadata, buffer);

  // Open the function definition
  openScope(buffer, useArrow);

  // Write the function definition
  generator(metadata, buffer);

  // Close the function definition
  closeScope(buffer, useArrow);
}
