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
import 'package:dogma_codegen/path.dart';
import 'package:logging/logging.dart';

import 'libraries.dart';
import 'io.dart';
import 'search.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// The logger for the library.
final Logger _logger = new Logger('dogma_codegen.src.build.converters');

/// Builds the convert library from the given [models] library.
///
/// The value of [models] is passed to [convertersLibrary] which transforms the
/// library into the equivalent unmodifiable version. The root of the library
/// is set to [libraryPath] while any exported libraries will be generated into
/// [sourcePath].
///
/// Additionally the [sourcePath] will be searched for any user defined
/// libraries which will be preferred over the generated equivalents.
///
/// The function will also write the resulting libraries to disk based on the
/// paths specified using the [writeUnmodifiableViews] function.
Future<Null> buildConverters(LibraryMetadata models,
                             Uri libraryPath,
                             Uri sourcePath) async
{
  // Search for any user defined libraries
  var userDefined = new List<LibraryMetadata>();

  await for (var library in findUserDefinedLibraries(sourcePath)) {
    var add = false;

    for (var converter in library.converters) {
      _logger.info('Found ${converter.name} in ${library.name}');
      add = true;
    }

    for (var function in library.functions) {
      _logger.info('Found ${function.name} in ${library.name}');
      add = true;
    }

    if (add) {
      _logger.info('Adding ${library.name} to user defined');
      userDefined.add(library);
    }
  }

  // Create the equivalent library
  var convert = convertersLibrary(
      models,
      libraryPath,
      sourcePath,
      userDefined: userDefined
  );

  await writeConvert(convert);
}

/// Writes the [convert] library to disk.
///
/// The value of [views] should be the root library which exports the others.
Future<Null> writeConvert(LibraryMetadata convert) async {
  for (var export in convert.exported) {
    _logger.info('Writing ${export.name} to disk at ${export.uri}');
    await writeConvertersLibrary(export);
  }

  _logger.info('Writing ${convert.name} to disk at ${convert.uri}');
  await writeRootLibrary(convert);
}

/// Transforms the [models] library into the equivalent library containing
/// converters.
///
/// The root of the library is set to [libraryPath] while any exported
/// libraries will be generated into [sourcePath].
LibraryMetadata convertersLibrary(LibraryMetadata modelLibrary,
                                  Uri libraryPath,
                                  Uri sourcePath,
                                 {List<LibraryMetadata> userDefined,
                                  bool decoders: true,
                                  bool encoders: true})
{
  userDefined ??= [];

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
                                   List<LibraryMetadata> userDefined,
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

      // \TODO actually should go by field just in case there's any function used here
      for (var dependency in modelDecoderDependencies(model)) {
        _logger.fine('Found dependency ${dependency.name}');
        for (var library in userDefined) {
          var function = findDecodeFunctionByType(library, dependency);

          if ((function != null) && (!imported.contains(library))) {
            _logger.fine('Found function ${function.name} for ${dependency.name}');
            imported.add(library);
          }
        }
      }
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
