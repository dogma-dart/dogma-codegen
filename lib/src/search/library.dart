// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains functions to search through library metadata.
library dogma_codegen.src.search.library;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import '../../metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Creates an iterable containing the [library] and the imported and exported
/// libraries, dependent on whether [includeImports] and [includeExports] are
/// true.
///
/// The libraries will be returned in a breadth first search form. The
/// [library] is returned first, followed by imports, and then exports. These
/// will be returned recursively.
Iterable<LibraryMetadata> _libraries(LibraryMetadata library,
                                     bool includeImports,
                                     bool includeExports) sync* {
  yield library;

  if (includeImports) {
    for (var import in library.imported) {
      yield* _libraries(import, includeImports, includeExports);
    }
  }

  if (includeExports) {
    for (var export in library.exported) {
      yield* _libraries(export, includeImports, includeExports);
    }
  }
}

/// Gets the metadata held within a [library].
///
/// This just includes the values of classes, functions, and fields within the
/// library. The [includeClasses], [includeFunctions] and [includeFields] allow
/// those values to be toggled on and off.
Iterable<Metadata> _libraryMetadata(LibraryMetadata library,
                                    bool includeClasses,
                                    bool includeFunctions,
                                    bool includeFields) sync* {
  if (includeClasses) {
    yield* library.classes;
  }

  if (includeFunctions) {
    yield* library.functions;
  }

  if (includeFields) {
    yield* library.fields;
  }
}

Iterable<Metadata> _expandLibraryMetadata(LibraryMetadata library,
                                          bool includeImports,
                                          bool includeExports,
                                          bool includeClasses,
                                          bool includeFunctions,
                                          bool includeFields) {
  // Get the libraries to search through
  var searchLibraries = _libraries(library, includeImports, includeExports);

  // Expand the metadata within the library
  return searchLibraries.expand/*<Metadata>*/(
      (value) => _libraryMetadata(value, includeClasses, includeFunctions, includeFields)
  );
}

Metadata libraryMetadataQuery(LibraryMetadata library,
                              MetadataMatchFunction matcher,
                             {bool includeImports: true,
                              bool includeExports: true,
                              bool includeClasses: true,
                              bool includeFunctions: true,
                              bool includeFields: true})
    =>
        _expandLibraryMetadata(
            library,
            includeImports,
            includeExports,
            includeClasses,
            includeFunctions,
            includeFields
        ).firstWhere(matcher, orElse: () => null);

Iterable<Metadata> libraryMetadataQueryAll(LibraryMetadata library,
                                           MetadataMatchFunction matcher,
                                          {bool includeImports: true,
                                           bool includeExports: true,
                                           bool includeClasses: true,
                                           bool includeFunctions: true,
                                           bool includeFields: true})
    =>
        _expandLibraryMetadata(
            library,
            includeImports,
            includeExports,
            includeClasses,
            includeFunctions,
            includeFields
        ).where(matcher);

//---------------------------------------------------------------------
// Metadata matching
//---------------------------------------------------------------------

typedef bool MetadataMatchFunction(Metadata metadata);

MetadataMatchFunction _nameMatch(String name) =>
    (metadata) => metadata.name == name;

bool _modelMetadataMatch(Metadata metadata) =>
    metadata is ModelMetadata;
bool _enumMetadataMatch(Metadata metadata) =>
    metadata is EnumMetadata;
bool _converterMetadataMatch(Metadata metadata) =>
    metadata is ConverterMetadata;
bool _converterFunctionMetadata(Metadata metadata) =>
    metadata is ConverterFunctionMetadata;

MetadataMatchFunction _typeMatch(TypeMetadata type) =>
    (metadata) => metadata is ClassMetadata && metadata.type == type;

MetadataMatchFunction _defaultDecoderMatch(TypeMetadata type) =>
    (metadata) =>
        metadata is ConverterFunctionMetadata &&
        metadata.isDefaultDecoder &&
        metadata.modelType == type;

MetadataMatchFunction _defaultEncoderMatch(TypeMetadata type) =>
    (metadata) =>
        metadata is ConverterFunctionMetadata &&
        metadata.isDefaultEncoder &&
        metadata.modelType == type;

//---------------------------------------------------------------------
// Metadata
//---------------------------------------------------------------------

Iterable<ModelMetadata> modelQueryAll(LibraryMetadata library) =>
    libraryMetadataQueryAll(
        library,
        _modelMetadataMatch,
        includeImports: false,
        includeExports: false,
        includeFunctions: false,
        includeFields: false
    );

Iterable<EnumMetadata> enumerationQueryAll(LibraryMetadata library) =>
    libraryMetadataQueryAll(
        library,
        _enumMetadataMatch,
        includeImports: false,
        includeExports: false,
        includeFunctions: false,
        includeFields: false
    );

Iterable<ConverterMetadata> converterQueryAll(LibraryMetadata library) =>
    libraryMetadataQueryAll(
        library,
        _converterMetadataMatch,
        includeImports: false,
        includeExports: false,
        includeFunctions: false,
        includeFields: false
    );

Iterable<ConverterMetadata> converterFunctionQueryAll(LibraryMetadata library) =>
    libraryMetadataQueryAll(
        library,
        _converterFunctionMetadata,
        includeImports: false,
        includeExports: false,
        includeFunctions: false,
        includeFields: false
    );

Metadata metadataByTypeQuery(LibraryMetadata library, TypeMetadata type) =>
    libraryMetadataQuery(
        library,
        _typeMatch(type),
        includeImports: false,
        includeExports: false
    );

Metadata metadataByNameQuery(LibraryMetadata library, String name) =>
    libraryMetadataQuery(
        library,
        _nameMatch(name),
        includeImports: false,
        includeExports: false
    );

ConverterFunctionMetadata defaultDecodeFunctionByTypeQuery(LibraryMetadata library,
                                                           TypeMetadata type) =>
    libraryMetadataQuery(
        library,
        _defaultDecoderMatch(type),
        includeImports: false,
        includeExports: false,
        includeClasses: false,
        includeFields: false
    );

ConverterFunctionMetadata defaultEncodeFunctionByTypeQuery(LibraryMetadata library,
                                                           TypeMetadata type) =>
    libraryMetadataQuery(
        library,
        _defaultEncoderMatch(type),
        includeImports: false,
        includeExports: false,
        includeClasses: false,
        includeFields: false
    );
