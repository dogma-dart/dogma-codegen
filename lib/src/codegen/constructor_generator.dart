// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.src.codegen.constructor_generator;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';

import 'annotated_metadata_generator.dart';
import 'annotation_generator.dart';
import 'argument_buffer.dart';
import 'parameter_generator.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

typedef void ConstructorGenerator(ConstructorMetadata constructor, StringBuffer bufer);

/// Generates a constructor declaration with the given [metadata] into the
/// [buffer].
///
/// The [useThis] value generates a declaration using the shorthand for setting
/// fields within the class where this.field is used.
void generateConstructorDeclaration(ConstructorMetadata metadata,
                                    StringBuffer buffer,
                                   {useThis: false}) {
  // Write out the factory declaration
  if (metadata.isFactory) {
    buffer.write('factory ');
  }

  // Write the constructor type
  buffer.write(metadata.returnType.name);

  // Write out the named constructor
  var name = metadata.name;

  if (name.isNotEmpty) {
    buffer.write('.$name');
  }

  // Write out the parameters
  generateParameters(metadata.parameters, buffer, useThis: useThis);
}

void generateConstructorDefinition(ConstructorMetadata metadata,
                                   StringBuffer buffer,
                                  {ConstructorGenerator initializerListGenerator,
                                   ConstructorGenerator generator,
                                   useThis: false,
                                   List<AnnotationGenerator> annotationGenerators}) {
  annotationGenerators ??= new List<AnnotationGenerator>();

  // Write out metadata
  generateAnnotatedMetadata(metadata, buffer, annotationGenerators);

  // Write the constructor declaration
  generateConstructorDeclaration(metadata, buffer, useThis: useThis);

  // Write the initializerList
  if (initializerListGenerator != null) {
    buffer.write(':');
    initializerListGenerator(metadata, buffer);
  }

  if (generator != null) {
    buffer.write('{');
    generator(metadata, buffer);
    buffer.writeln('}');
  } else {
    buffer.writeln(';');
  }
}

/// Generates a constructor definition with the given [metadata] into the
/// [buffer] where each parameter corresponds to a field.
void generateFinalContructor(ConstructorMetadata metadata,
                             StringBuffer buffer,
                            {List<AnnotationGenerator> annotationGenerators})
    => generateConstructorDefinition(metadata,
                                     buffer,
                                     useThis: true,
                                     annotationGenerators: annotationGenerators);
