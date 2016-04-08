// Copyright (c) 2015-2016, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_source_analyzer/metadata.dart';

import 'annotation.dart';
import 'argument_buffer.dart';
import 'annotated_metadata.dart';
import 'type_metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Definition of a function that generates the source code for a class from
/// the [metadata].
///
/// The source code generated is written into the [buffer].
typedef void ClassGenerator(ClassMetadata metadata, StringBuffer buffer);

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

  // Write the with clause if necessary
  var mixins = metadata.mixins;

  if (mixins.isNotEmpty) {
    buffer.write(' with ');

    writeArgumentsToBuffer(
        mixins.map/*<String>*/((type) => generateType(type)),
        buffer
    );
  }

  // Write the implements clause if necessary
  var interfaces = metadata.interfaces;

  if (interfaces.isNotEmpty) {
    buffer.write(' implements ');

    writeArgumentsToBuffer(
        interfaces.map/*<String>*/((type) => generateType(type)),
        buffer
    );
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
