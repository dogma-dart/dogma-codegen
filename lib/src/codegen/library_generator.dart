// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.src.codegen.library_generator;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';
import 'package:path/path.dart' show posix;

import 'code_formatter.dart';
import 'enum_converter_generator.dart';
import 'model_converter_generator.dart';
import 'model_generator.dart';
import 'template.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

String generateConverters(LibraryMetadata metadata) {
  var buffer = new StringBuffer();
  print(libraryTemplateValues(metadata));

  // Write the models
  for (var model in metadata.models) {
    buffer.writeln(generateModelDecoder(model));
    buffer.writeln(generateModelEncoder(model));
  }

  // Write the enumerations
  for (var enumeration in metadata.enumerations) {
    buffer.writeln(generateEnumConverter(enumeration));
  }

  return formatCode(buffer);
}

String generateUnmodifiableModels(LibraryMetadata metadata) {
  var buffer = new StringBuffer();
  print(libraryTemplateValues(metadata));

  for (var model in metadata.models) {
    buffer.writeln(generateUnmodifiableModelView(model));
  }

  return formatCode(buffer);
}

String generateModels(LibraryMetadata metadata) {
  var buffer = new StringBuffer();

  for (var model in metadata.models) {
    buffer.writeln(generateModel(model));
  }

  return formatCode(buffer);
}

String generateModelLibrary(LibraryMetadata metadata) {
  var buffer = new StringBuffer();

  for (var model in metadata.models) {
    buffer.writeln(generateModel(model));
  }

  var values = libraryTemplateValues(metadata);
  values['code'] = formatCode(buffer);
  values['generatedHeader'] = '';
  values['header'] = '';

  return template().renderString(values);
}

Map libraryTemplateValues(LibraryMetadata metadata) {
  var values = {
      'libraryName': metadata.name
  };

  // Get the directory containing the library
  var libraryDirectory = posix.dirname(metadata.uri.toFilePath(windows: false));

  // Get information on the imports
  var standardLibraries = [];
  var packageImports = [];
  var relativeImports = [];

  for (var import in metadata.imported) {
    var uri = import.uri;

    switch (uri.scheme) {
      case 'dart':
        standardLibraries.add(uri.toString());
        break;
      case 'package':
        packageImports.add(uri.toString());
        break;
      case 'file':
        relativeImports.add(posix.relative(uri.toFilePath(windows: false), from: libraryDirectory));
        break;
    }
  }

  // Add the standardLibraries information if applicable
  values['standardLibraries'] = standardLibraries.isNotEmpty
      ? { 'libraries': standardLibraries }
      : null;

  // Add the imports information if applicable
  values['imports'] = packageImports.isNotEmpty || relativeImports.isNotEmpty
      ? { 'packages': packageImports, 'relative': relativeImports }
      : null;

  // Get information on the exports
  var packageExports = [];
  var relativeExports = [];

  for (var export in metadata.exported) {
    var uri = export.uri;

    switch (uri.scheme) {
      case 'package':
        packageExports.add(uri.toString());
        break;
      case 'file':
        relativeExports.add(posix.relative(uri.toFilePath(windows: false), from: libraryDirectory));
        break;
    }
  }

  // Add the exports information if applicable
  values['exports'] = packageExports.isNotEmpty || relativeExports.isNotEmpty
      ? { 'packages': packageExports, 'relative': relativeExports }
      : null;

  return values;
}
