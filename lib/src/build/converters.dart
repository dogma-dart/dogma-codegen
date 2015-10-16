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

import 'package:dogma_codegen/metadata.dart';
import 'package:dogma_codegen/identifier.dart';
import 'package:dogma_codegen/path.dart';
import 'package:logging/logging.dart';

import 'libraries.dart';
import 'io.dart';
import 'search.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// The input parameter into the convert method.
const String _input = 'input';

/// The logger for the library.
final Logger _logger = new Logger('dogma_codegen.src.build.converters');
/// Type metadata for a DateTime.
///
/// DateTime can be automatically converted.
final TypeMetadata _dateTimeType = new TypeMetadata('DateTime');
/// Type metadata for a URI.
///
/// Uri can be automatically converted.
final TypeMetadata _uriType = new TypeMetadata('Uri');

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

/// Derives the encode function name for the given enumeration [name].
String encodeEnumFunction(String name) {
  return 'encode$name';
}

/// Derives the decode function name for the given enumeration [name].
String decodeEnumFunction(String name) {
  return 'decode$name';
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
    // Create the decoder
    if (decoders) {
      converters.add(_converterMetadata(
          model,
          modelLibrary,
          imported,
          userDefined,
          true
      ));
    }

    // Create the encoder
    if (encoders) {
      converters.add(_converterMetadata(
          model,
          modelLibrary,
          imported,
          userDefined,
          false
      ));
    }

    // Add the dependencies
    //
    // \TODO this currently assumes that everything is going to be used which might not be the case
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
    imported.addAll([dartConvert, dogmaConvert]);
  }

  // Create the enum converters
  var functions = [];

  for (var enumeration in library.enumerations) {
    // Create the type
    var name = enumeration.name;
    var type = new TypeMetadata(name);
    var encodeType = enumeration.encodeType;

    if (decoders) {
      functions.add(new ConverterFunctionMetadata(
          decodeEnumFunction(name),
          type,
          new ParameterMetadata('value', encodeType),
          modelParameter: new ParameterMetadata(
              'defaultsTo',
              type,
              parameterKind: ParameterKind.optional,
              defaultValue: enumeration.fields[0]
          ),
          isDefaultConverter: true
      ));
    }

    if (encoders) {
      functions.add(new ConverterFunctionMetadata(
          encodeEnumFunction(name),
          encodeType,
          new ParameterMetadata('value', type),
          isDefaultConverter: true
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

ConverterMetadata _converterMetadata(ModelMetadata model,
                                     LibraryMetadata modelLibrary,
                                     List<LibraryMetadata> imported,
                                     List<LibraryMetadata> userDefined,
                                     bool decoder) {
  var findConvertFunction = decoder
      ? findDecodeFunctionByType
      : findEncodeFunctionByType;

  // Search for dependencies to determine the fields for the converter
  var fields = new Map<String, FieldMetadata>();

  for (SerializableFieldMetadata modelField in model.fields) {
    // Get the field information
    var fieldName = modelField.name;
    var fieldType = modelField.type;

    // See if the model field has an explicit function to use
    var convertUsing = decoder ? modelField.decodeUsing : modelField.encodeUsing;

    if (convertUsing != null) {
      _logger.finest('Field $fieldName uses $convertUsing for conversion');
      var function;

      for (var library in userDefined) {
        function = findFunction(library, convertUsing);

        if (function != null) {
          if (!imported.contains(library)) {
            imported.add(library);
          }

          break;
        }
      }

      continue;
    }

    // Determine if the type requires conversion
    if (fieldType.isBuiltin) {
      _logger.finest('Field $fieldName uses a builtin ${fieldType.name}');
      continue;
    }

    // Get the actual type
    var type = _findUserDefinedType(fieldType);
    var typeName = type.name;

    // Determine if the type is the same as the converter
    if (type == model.type) {
      _logger.finest('Field $fieldName is the same type, ${fieldType.name}, as the model');
      continue;
    }

    // Determine if the type is an enumeration
    var enumeration = findEnumeration(modelLibrary, typeName);

    if (enumeration != null) {
      _logger.finest('Field $fieldName uses an enum $typeName');
      continue;
    }

    // Determine if the type is decoded with a function
    var function;

    for (var library in userDefined) {
      function = findConvertFunction(library, type);

      if (function != null) {
        if (!imported.contains(library)) {
          imported.add(library);
        }

        break;
      }
    }

    if (function != null) {
      _logger.finest('Field $fieldName will be converted using ${function.name}');
      continue;
    }

    // Determine if the type has converters
    if ((type == _dateTimeType) || (type == _uriType)) {
      _logger.finest('Field $fieldName uses ${fieldType.name} which has automatic converters');
      continue;
    }

    // See if the field was already created
    if (fields.containsKey(typeName)) {
      _logger.finest('Converter for $typeName already present');
      continue;
    }

    var converterFieldName = '_' + pascalToCamelCase(typeName) +
        (decoder ? 'Decoder' : 'Encoder');

    fields[typeName] = new FieldMetadata(
        converterFieldName,
        ConverterMetadata.converter(type, decoder),
        false,
        true,
        true,
        isFinal: true
    );
  }

  // Create constructors if fields need to be initialized
  var constructors = new List<ConstructorMetadata>();

  if (fields.isNotEmpty) {
    _logger.finest('Generating constructors for coverter');

    var constructorType = new TypeMetadata(
       ConverterMetadata.defaultConverterName(model.type, decoder)
    );

    // Add a default constructor
    constructors.add(new ConstructorMetadata(constructorType));

    // Add a named constructor
    var constructorParameters = new List<ParameterMetadata>();

    for (var field in fields.values) {
      constructorParameters.add(new ParameterMetadata(field.name, field.type));
    }

    constructors.add(
        new ConstructorMetadata.named(
            'using',
            constructorType,
            parameters: constructorParameters)
    );
  } else {
    _logger.finest('Can use default constructor for converter');
  }

  // Create the methods
  var methods = new List<MethodMetadata>();

  // Add the create method
  if (decoder) {
    methods.add(
        new MethodMetadata(
            'create',
            model.type,
            annotations: [override]
        )
    );
  }

  // Add the convert method
  var parameters = new List<ParameterMetadata>();
  var modelType = model.type;
  var mapType = new TypeMetadata.map();
  var returnType;

  if (decoder) {
    returnType = modelType;
    parameters
        ..add(new ParameterMetadata(_input, mapType))
        ..add(new ParameterMetadata(
            'model',
            modelType,
            parameterKind: ParameterKind.optional
        ));
  } else {
    returnType = mapType;
    parameters.add(new ParameterMetadata(_input, modelType));
  }

  methods.add(new MethodMetadata(
      'convert',
      returnType,
      parameters: parameters,
      annotations: [override]
  ));

  var comments = _converterComments(modelType.name, decoder);
  var converterFields = fields.values.toList();

  // \TODO Use generalized tear offs https://github.com/dart-lang/sdk/issues/23774
  return decoder
      ? new ConverterMetadata.decoder(modelType,
                                      fields: converterFields,
                                      methods: methods,
                                      constructors: constructors,
                                      comments: comments)
      : new ConverterMetadata.encoder(modelType,
                                      fields: converterFields,
                                      methods: methods,
                                      constructors: constructors,
                                      comments: comments);
}

TypeMetadata _findUserDefinedType(TypeMetadata metadata) {
  if (metadata.isList) {
    return _findUserDefinedType(metadata.arguments[0]);
  } else if (metadata.isMap) {
    return _findUserDefinedType(metadata.arguments[1]);
  } else {
    return metadata;
  }
}

String _converterComments(String type, bool decoder) {
  var converter = decoder ? 'ModelDecoder' : 'ModelEncoder';

  return 'A [$converter] for [$type].';
}
