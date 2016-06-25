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

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Function type for writing a [constructor] into a [buffer].
typedef void ConstructorGenerator(ConstructorMetadata constructor, StringBuffer buffer);

/// Generates a constructor declaration with the given [metadata] into the
/// [buffer].
void generateConstructorDeclaration(ConstructorMetadata metadata,
                                    StringBuffer buffer) {
  // Write out the factory declaration
  if (metadata.isFactory) {
    buffer.write('factory ');
  }

  // Write out the const declaration
  if (metadata.isConst) {
    buffer.write('const ');
  }

  // Write the constructor type
  buffer.write(metadata.returnType.name);

  // Write out the named constructor
  var name = metadata.name;

  if (name.isNotEmpty) {
    buffer.write('.$name');
  }

  // Write out the parameters
  generateParameters(metadata.parameters, buffer);
}

/// Generates a constructor definition with the given [metadata] into the
/// [buffer].
///
/// An [initializerListGenerator] can be used to fill out an initializer list
/// within the constructor. A [generator] is used to make the definition of the
/// constructor.
void generateConstructorDefinition(ConstructorMetadata metadata,
                                   StringBuffer buffer,
                                  {ConstructorGenerator initializerListGenerator,
                                   ConstructorGenerator generator,
                                   bool useArrow: false,
                                   List<AnnotationGenerator> annotationGenerators}) {
  // Write out metadata
  generateAnnotatedMetadata(metadata, buffer, annotationGenerators);

  // Write the constructor declaration
  generateConstructorDeclaration(metadata, buffer);

  // Write the initializerList
  if (initializerListGenerator != null) {
    buffer.write(':');
    initializerListGenerator(metadata, buffer);
  }

  if (generator != null) {
    openScope(buffer, useArrow);
    generator(metadata, buffer);
    closeScope(buffer, useArrow);
  } else {
    buffer.writeln(';');
  }
}
