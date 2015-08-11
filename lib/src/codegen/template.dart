// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Functionality for working with mustache templates.
library dogma_codegen.src.codegen.template;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:mustache/mustache.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Creates a mustache template with the given [source].
///
/// The template is expected to be able to handle the following data structure
/// which mirrors the contents of a .dart file.
///
///     {
///       'generatedHeader': '...'       // String containing the generated definition
///       'header': '...'                // Copyright header
///       'libraryName': '...'           // The name of the library
///       'standardLibraries': {
///         'libraries': ['..',...,'..'] // A list of standard libraries
///       },
///       'imports' {
///         'packages': ['..',...,'..'], // A list of package imports
///         'relative': ['..',...,'..'], // A list of relative package imports
///       },
///       'exports' {
///         'packages': ['..',...,'..'], // A list of package exports
///         'relative': ['..',...,'..'], // A list of relative package exports
///       },
///       'code': '...'                  // Source code for the library
///     }
Template template([String source]) => new Template(source ?? _defaultSource);

/// The default template source for code generation.
final String _defaultSource =
'''{{{generatedHeader}}}
{{{header}}}


library {{libraryName}};

{{#standardLibraries}}

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------


{{#libraries}}
import '{{{.}}}';
{{/libraries}}
{{/standardLibraries}}
{{#imports}}

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------


{{#packages}}
import '{{{.}}}';
{{/packages}}
{{#relative}}
import '{{{.}}}';
{{/relative}}
{{/imports}}
{{#exports}}

//---------------------------------------------------------------------
// Exports
//---------------------------------------------------------------------


{{#packages}}
export '{{{.}}}';
{{/packages}}
{{#relative}}
export '{{{.}}}';
{{/relative}}
{{/exports}}

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------


{{{code}}}
''';
