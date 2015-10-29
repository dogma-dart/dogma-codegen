// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains functions to write out class declarations.
library dogma_codegen.src.codegen.function_generator;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';

import 'annotated_metadata_generator.dart';
import 'annotation_generator.dart';
import 'parameter_generator.dart';
import 'type_generator.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Definition of a function that generates the source code for a function.
///
/// The source code generated is written into the [buffer].
typedef void FunctionGenerator(FunctionMetadata function, StringBuffer buffer);

void generateFunctionDeclaration(FunctionMetadata metadata, StringBuffer buffer) {
  buffer.write(generateType(metadata.returnType));
  buffer.write(' ');
  buffer.write(metadata.name);

  generateParameters(metadata.parameters, buffer);
}

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
  if (useArrow) {
    buffer.write('=>');
  } else {
    buffer.writeln('{');
  }

  // Write the function definition
  generator(metadata, buffer);

  // Close the function definition
  if (!useArrow) {
    buffer.writeln('}');
  }
}
