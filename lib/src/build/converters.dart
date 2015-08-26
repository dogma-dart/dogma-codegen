// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.src.build.converters;

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:async';

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/codegen.dart';
import 'package:dogma_codegen/metadata.dart';
import 'package:dogma_codegen/io.dart';
import 'package:dogma_codegen/path.dart';

import 'libraries.dart';
import 'search.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

Future<Null> buildConverters(LibraryMetadata models,
                             Uri libraryPath,
                             Uri sourcePath) async
{
  await for (var library in findUserDefinedLibraries(sourcePath)) {
    print(library.uri);

    for (var converter in library.converters) {
      print(converter.name);
    }

    for (var function in library.functions) {
      print(function.name);
    }
  }

  for (var export in models.exported) {
    await writeConvertersLibrary(export);
  }

  await writeRootLibrary(models);
}

LibraryMetadata convertersLibrary(LibraryMetadata modelLibrary,
                                  Uri libraryPath,
                                  Uri sourcePath,
                                 {Map<String, LibraryMetadata> userDefined,
                                  bool decoders: true,
                                  bool encoders: true})
{
  userDefined ??= {};

  var packageName = modelLibrary.name.split('.')[0];

  // Convert the modelLibrary into the equivalent using package notation.
  modelLibrary = packageLibrary(modelLibrary);

  // Get the exported libraries
  var exported = new List<LibraryMetadata>();
  var loaded = {};

  for (var export in modelLibrary.exported) {
    exported.add(_convertersLibrary(
        export,
        modelLibrary,
        packageName,
        sourcePath,
        loaded,
        userDefined,
        decoders,
        encoders
    ));
  }

  // Get the package name from the library
  var name = libraryName(packageName, libraryPath);

  return new LibraryMetadata(name, libraryPath, exported: exported);
}

LibraryMetadata _convertersLibrary(LibraryMetadata library,
                                   LibraryMetadata modelLibrary,
                                   String packageName,
                                   Uri sourcePath,
                                   Map<String, LibraryMetadata> loaded,
                                   Map<String, LibraryMetadata> userDefined,
                                   bool decoders,
                                   bool encoders)
{
  // Check to see if the library was already loaded
  var loadingName = library.name;

  if (loaded.containsKey(loadingName)) {
    return loaded[loadingName];
  }

  // Model library should always be included
  var imported = [modelLibrary] as List<LibraryMetadata>;

  // Create the converters
  var converters = [];

  for (var model in library.models) {
    // Create the type
    var name = model.name;
    var type = new TypeMetadata(name);

    // Create the decoder
    if (decoders) {
      converters.add(new ConverterMetadata('${name}Decoder', type, true));
    }

    // Create the encoder
    if (encoders) {
      converters.add(new ConverterMetadata('${name}Encoder', type, false));
    }

    // Add the dependencies
    //
    // \TODO this currently assumes that everything is going to be used which
    // might not be the case
    for (var import in library.imported) {
      if (import.uri.scheme == 'file') {
        imported.add(_convertersLibrary(
            import,
            modelLibrary,
            packageName,
            sourcePath,
            loaded,
            userDefined,
            decoders,
            encoders
        ));
      }
    }
  }

  if (converters.isNotEmpty) {
    imported.addAll([dartConvert, dogmaData]);
  }

  // Create the enum converters
  var functions = [];

  for (var enumeration in library.enumerations) {
    // Create the type
    var name = enumeration.name;
    var type = new TypeMetadata(name);
    // \TODO Get the actual type
    var encodeType = new TypeMetadata('String');

    if (decoders) {
      functions.add(new FunctionMetadata(
          decodeEnumFunction(name),
          encodeType, // Input
          type,       // Output
          decoder: true
      ));
    }

    if (encoders) {
      functions.add(new FunctionMetadata(
          encodeEnumFunction(name),
          type,       // Input
          encodeType, // Output
          decoder: false
      ));
    }
  }

  if (functions.isNotEmpty) {
    imported.add(dogmaSerialize);
  }

  // Get the library name and path
  var baseName = basenameWithoutExtension(library.uri);
  var uri = join('${baseName}_convert.dart', base: sourcePath);
  var name = libraryName(packageName, uri);

  var generatedLibrary = new LibraryMetadata(
      name,
      uri,
      imported: imported,
      converters: converters,
      functions: functions
  );

  // Note that the library is loaded
  //
  // The name of the library being converted is used as that is already known
  loaded[loadingName] = generatedLibrary;

  return generatedLibrary;
}