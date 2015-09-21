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
import 'comment_generator.dart';
import 'type_generator.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Definition of a function that generates the source code for a class.
///
/// The source code generated is written into the [buffer].
typedef void ClassGenerator(ClassMetadata field, StringBuffer buffer);

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

    var argumentBuffer = new ArgumentBuffer();

    for (var implementation in implements) {
      argumentBuffer.write(generateType(implementation));
    }

    buffer.write(argumentBuffer.toString());
  }
}

void generateClassDefinition(ClassMetadata metadata,
                             StringBuffer buffer,
                             ClassGenerator generator,
                            {List<AnnotationGenerator> annotationGenerators})
{
  annotationGenerators ??= new List<AnnotationGenerator>();

  // Write the code comment
  generateCodeComment(metadata.comments, buffer);

  // Write out any annotations
  for (var annotation in metadata.annotations) {
    for (var annotationGenerator in annotationGenerators) {
      annotationGenerator(annotation, buffer);
    }
  }

  // Write the class declaration
  generateClassDeclaration(
      metadata,
      buffer,
      metadata is EnumMetadata ? 'enum' : 'class'
  );
  buffer.writeln('{');

  // Write the class definition
  generator(metadata, buffer);

  // Close the class declaration
  buffer.writeln('}');
}
