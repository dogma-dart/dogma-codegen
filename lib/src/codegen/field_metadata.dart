// Copyright (c) 2015-2016 the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_source_analyzer/metadata.dart';

import 'annotation.dart';
import 'annotated_metadata.dart';
import 'builtin_generator.dart';
import 'scope.dart';
import 'type_metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Definition of a function that generates the source code for a field.
///
/// The source code generated is written into the [buffer].
typedef void FieldGenerator(FieldMetadata field, StringBuffer buffer);

/// Generates the source code for the field [metadata] into the [buffer] using
/// the [generator].
///
/// Any annotations that are present on the [metadata] are passed to the
/// [annotationGenerators].
void generateField(FieldMetadata metadata,
                   StringBuffer buffer,
                   FieldGenerator generator,
                   List<AnnotationGenerator> annotationGenerators)
{
  // Write out metadata
  generateAnnotatedMetadata(metadata, buffer, annotationGenerators);

  // Write the declaration
  generator(metadata, buffer);
}

/// Generates the source code for the [fields] into the [buffer].
///
/// The [fieldGenerator] specifies the function to write the source code for the
/// field. By default it is assumed that this is just a member variable and the
/// [generateFieldDeclaration] function is used. If a getter/setter pair is
/// required then [getterGenerator] and [setterGenerator] can be used for
/// generating the output.
///
/// Any annotations that are present on the [fields] are passed to the
/// [annotationGenerators].
void generateFields(Iterable<FieldMetadata> fields,
                    StringBuffer buffer,
                   {FieldGenerator fieldGenerator,
                    FieldGenerator getterGenerator,
                    FieldGenerator setterGenerator,
                    List<AnnotationGenerator> annotationGenerators})
{
  fieldGenerator ??= generateFieldDeclaration;

  for (var field in fields) {
    if (field.isProperty) {
      generateAnnotatedMetadata(field, buffer, annotationGenerators);

      if (field.getter) {
        assert(getterGenerator != null);
        generateGetterDefinition(field, buffer, getterGenerator);
      }

      if (field.setter) {
        assert(setterGenerator != null);
        generateSetterDefinition(field, buffer, setterGenerator);
      }
    } else {
      generateField(
          field,
          buffer,
          fieldGenerator,
          annotationGenerators
      );
    }
  }
}

/// Generates the source code of the [metadata] into the [buffer] for a member
/// variable declaration.
void generateFieldDeclaration(FieldMetadata metadata, StringBuffer buffer) {
  // Write out a static declaration
  if (metadata.isStatic) {
    buffer.write('static ');
  }

  var isConst = metadata.isConst;

  // Write out const and final declaration
  if (isConst) {
    buffer.write('const ');
  } else if (metadata.isFinal) {
    buffer.write('final ');
  }

  buffer.write('${generateType(metadata.type)} ${metadata.name}');

  // Write out the default value if necessary
  var defaultValue = metadata.defaultValue;

  if (defaultValue != null) {
    buffer.write('=');
    buffer.write(generateBuiltin(defaultValue, isConst: isConst));
  }

  // Terminate the declaration
  buffer.writeln(';');
}

/// Creates a getter declaration for the field [metadata] into the [buffer].
void generateGetterDeclaration(FieldMetadata metadata, StringBuffer buffer) {
  // Write out a static declaration
  if (metadata.isStatic) {
    buffer.write('static ');
  }

  buffer.write('${generateType(metadata.type)} get ${metadata.name}');
}

/// Creates a setter declaration for the field [metadata] into the [buffer].
void generateSetterDeclaration(FieldMetadata metadata,
                               StringBuffer buffer,
                              [String parameterName = 'value']) {
  // Write out a static declaration
  if (metadata.isStatic) {
    buffer.write('static ');
  }

  buffer.write('set ${metadata.name}(${generateType(metadata.type)} $parameterName)');
}

/// Creates the definition of a getter for the field [metadata] into the
/// [buffer] using the [generator] for the body.
///
/// If [useArrow] is true then an arrow function will be generated.
void generateGetterDefinition(FieldMetadata metadata,
                              StringBuffer buffer,
                              FieldGenerator generator,
                             {bool useArrow: true}) {
  // Write the getter declaration
  generateGetterDeclaration(metadata, buffer);

  // Open the getter definition
  openScope(buffer, useArrow);

  // Write the getter definition
  generator(metadata, buffer);

  // Close the getter definition
  closeScope(buffer, useArrow);
}

/// Creates the definition of a setter for the field [metadata] into the
/// [buffer] using the [generator] for the body.
void generateSetterDefinition(FieldMetadata metadata,
                              StringBuffer buffer,
                              FieldGenerator generator) {
  // Write the setter declaration
  generateSetterDeclaration(metadata, buffer);

  // Open the setter definition
  openScope(buffer);

  // Write the setter definition
  generator(metadata, buffer);

  // Close the getter definition
  closeScope(buffer);
}
