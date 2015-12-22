// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains functions to write out class declarations.
library dogma_codegen.src.codegen.class_generator;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';

import 'annotation_generator.dart';
import 'argument_buffer.dart';
import 'annotated_metadata_generator.dart';
import 'type_generator.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Definition of a function that generates the source code for a class.
///
/// The source code generated is written into the [buffer].
typedef void ClassGenerator(ClassMetadata field, StringBuffer buffer);

/// Generates the declaration for the [metadata] into the [buffer].
///
/// The [keyword] can be specified for cases where 'class' is not the required
/// keyword for the declaration.
void generateClassDeclaration(ClassMetadata metadata,
                              StringBuffer buffer,
                             [String keyword = 'class']) {
  buffer.write('$keyword ');
  buffer.write(generateType(metadata.type));

  // Write the extends clause if necessary
  var supertype = metadata.supertype;

  if (supertype != null) {
    buffer.write(' extends ');
    buffer.write(generateType(supertype));
  }

  // Write the implements clause if necessary
  var implements = metadata.implements;

  if (implements.isNotEmpty) {
    buffer.write(' implements ');

    writeArgumentsToBuffer(implements.map((type) => generateType(type)), buffer);
  }
}

/// Generates the source code for the class [metadata] into the [buffer].
///
/// The [generator] specifies the function to write the source code for the
/// class definition.
///
/// Any annotations that are present on the [metadata] are passed to the
/// [annotationGenerators].
void generateClassDefinition(ClassMetadata metadata,
                             StringBuffer buffer,
                             ClassGenerator generator,
                            {List<AnnotationGenerator> annotationGenerators}) {
  annotationGenerators ??= <AnnotationGenerator>[];

  // Write out metadata
  generateAnnotatedMetadata(metadata, buffer, annotationGenerators);

  // Write the class declaration
  generateClassDeclaration(
      metadata,
      buffer,
      metadata is EnumMetadata ? 'enum' : 'class'
  );
  buffer.writeln('{');

  // Write the class definition
  generator(metadata, buffer);

  // Close the class definition
  buffer.writeln('}');
}
