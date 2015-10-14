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
  // Get the converter functions
  var decoderFunctions = _defaultDecoders();
  var encoderFunctions = _defaultEncoders();

  for (var import in library.imported) {
    for (var function in import.functions) {
      // See if the function can be used as a converter
      if (function is ConverterFunctionMetadata) {
        // See if the function is a default function
        if (function.isDefaultConverter) {
          var functions = function.isDecoder
              ? decoderFunctions
              : encoderFunctions;

          functions[function.modelType.name] = function;
        } else {
          // Could be used for encoding or decoding
          var name = function.name;

          decoderFunctions[name] = function;
          encoderFunctions[name] = function;
        }
      }
    }
  }

  // Look for converters
  for (var converter in library.converters) {
    var model = findModel(library, converter.modelType.name);

    var functions = converter.isDecoder ? decoderFunctions : encoderFunctions;

    generateConverter(converter, model, buffer, functions: functions);
  }

  // Look for enumerations
  for (var function in library.functions) {
    if ((function is ConverterFunctionMetadata) && (function.isDefaultConverter)) {
      var enumeration = findEnumeration(library, function.modelType.name);

      if (enumeration != null) {
        if (function.isDecoder) {
          generateEnumDecoder(function, enumeration, buffer);
        } else {
          generateEnumEncoder(function, enumeration, buffer);
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

Map<String, MethodMetadata> _defaultEncoders() {
  return {
    'DateTime': new MethodMetadata('toString', new TypeMetadata.string()),
    'Uri': new MethodMetadata('toString', new TypeMetadata.string())
  };
}
