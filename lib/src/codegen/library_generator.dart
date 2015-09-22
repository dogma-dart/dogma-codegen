// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.src.codegen.library_generator;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';
import 'package:dogma_codegen/template.dart';

import 'enum_generator.dart';
import 'enum_converter_generator.dart';
import 'model_converter_generator.dart';
import 'model_generator.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Definition of a library generator.
typedef String LibraryGenerator(LibraryMetadata library);
/// Definition of a source code generator.
typedef void _SourceGenerator(LibraryMetadata library, StringBuffer buffer);

/// Generates the source code for models within a [library] into the [buffer].
void generateModelsSource(LibraryMetadata library, StringBuffer buffer) {
  for (var model in library.models) {
    generateModel(model, buffer);
  }

  for (var enumeration in library.enumerations) {
    generateEnum(enumeration, buffer);
  }
}

/// Generates the source code for unmodifiable model views within a [library]
/// into the [buffer].
void generateUnmodifiableModelViewsSource(LibraryMetadata library, StringBuffer buffer) {
  for (var model in library.models) {
    generateUnmodifiableModelView(model, buffer);
  }
}

/// Generates the source code for converters within a [library] into the
/// [buffer].
void generateConvertersSource(LibraryMetadata library,
                              StringBuffer buffer)
{
  for (var converter in library.converters) {
    var model = findModel(library, converter.modelType.name);

    if (converter.isDecoder) {
      generateModelFieldVariables(model, buffer);
      generateModelDecoder(converter, model, buffer, decodeThrough: _defaultDecoders());
    } else {
      generateModelEncoder(model, buffer);
    }
  }

  // Look for enumerations
  for (var function in library.functions) {
    if ((function is ConverterFunctionMetadata) && (function.isDefaultConverter)) {
      var enumeration = findEnumeration(library, function.modelType.name);

      if (enumeration != null) {
        if (function.isDecoder) {
          generateEnumDecoder(enumeration, buffer);
        } else {
          generateEnumEncoder(enumeration, buffer);
        }
      }
    }
  }
}

/// Generates the source code for a [library] that has no content.
///
/// This is used to handle root libraries which just export libraries.
String generateRootLibrary(LibraryMetadata library)
    => renderLibrary(library, '');

/// Generates the source code for a [library] containing models.
String generateModelsLibrary(LibraryMetadata library)
    => _renderLibrary(library, generateModelsSource);

/// Generates the source code for a [library] containing unmodifiable views of models.
String generateUnmodifiableModelViewsLibrary(LibraryMetadata library)
    => _renderLibrary(library, generateUnmodifiableModelViewsSource);

/// Generates the source code for a [library] containing converters for models.
String generateConvertersLibrary(LibraryMetadata library)
    => _renderLibrary(library, generateConvertersSource);

/// Generates the source code for a [library] with the given source [generator].
String _renderLibrary(LibraryMetadata library, _SourceGenerator generator) {
  var buffer = new StringBuffer();

  generator(library, buffer);

  return renderLibrary(library, buffer.toString().trim());
}

Map<String, FunctionMetadata> _defaultDecoders() {
  return {
    'DateTime': new ConverterFunctionMetadata(
        'DateTime.parse',
        new TypeMetadata('String'),
        new ParameterMetadata('value', new TypeMetadata('DateTime'))
    ),
    'Uri': new ConverterFunctionMetadata(
        'Uri.parse',
        new TypeMetadata('String'),
        new ParameterMetadata('value', new TypeMetadata('Uri'))
    )
  };
}
