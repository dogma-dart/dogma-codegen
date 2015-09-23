// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.src.codegen.field_generator;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';

import 'annotation_generator.dart';
import 'annotated_metadata_generator.dart';
import 'builtin_generator.dart';
import 'type_generator.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Definition of a function that generates the source code for a field.
///
/// The source code generated is written into the [buffer].
typedef void FieldGenerator(FieldMetadata field, StringBuffer buffer);

/// Generates the source code for the [field] into the [buffer] using the
/// [generator].
///
/// Any annotations that are present on the [field] are passed to the
/// [annotationGenerators].
void generateField(FieldMetadata field,
                   StringBuffer buffer,
                   FieldGenerator generator,
                   List<AnnotationGenerator> annotationGenerators)
{
  // Write out metadata
  generateAnnotatedMetadata(field, buffer, annotationGenerators);

  // Write the declaration
  generator(field, buffer);
}

/// Generates the source code for the [fields] into the [buffer].
///
/// The [generator] specifies the function to write the source code for the
/// field. By default it is assumed that this is just a member variable and the
/// [generateMemberVariable] function is used.
///
/// Any annotations that are present on the [fields] are passed to the
/// [annotationGenerators].
void generateFields(List<FieldMetadata> fields,
                    StringBuffer buffer,
                   {FieldGenerator generator,
                    List<AnnotationGenerator> annotationGenerators})
{
  generator ??= generateMemberVariable;
  annotationGenerators ??= new List<AnnotationGenerator>();

  for (var field in fields) {
    generateField(
        field,
        buffer,
        generator,
        annotationGenerators
    );
  }
}

/// Generates the source code of the [field] into the [buffer] for a member
/// variable declaration.
///
/// This function does not initialize the member variable in the generated
/// code.
void generateMemberVariable(FieldMetadata field, StringBuffer buffer) {
  buffer.writeln('${generateType(field.type)} ${field.name};');
}

void generateFieldDeclaration(FieldMetadata field, StringBuffer buffer) {
  // Write out a static declaration
  if (field.isStatic) {
    buffer.write('static ');
  }

  var isConst = field.isConst;

  // Write out const and final declaration
  if (isConst) {
    buffer.write('const ');
  } else if (field.isFinal) {
    buffer.write('final ');
  }

  buffer.write('${generateType(field.type)} ${field.name}');

  // Write out the default value if necessary
  var defaultValue = field.defaultValue;

  if (defaultValue != null) {
    buffer.write('=');
    buffer.write(generateBuiltin(defaultValue, isConst: isConst));
  }

  // Terminate the declaration
  buffer.writeln(';');
}
