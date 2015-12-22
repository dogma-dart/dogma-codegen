// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.src.template.class_declaration;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:mustache/mustache.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// The path to the default mustache template.
///
/// Package resources are loaded through the Resource API added in Dart 1.12.
const String defaultClassTemplate =
    'package:dogma_codegen/src/template/class_declaration.mustache';

/// The template to use for rendering.
Template _template;

/// Sets the [source] to use for the class template.
///
/// This will overwrite the current template and any subsequent calls to
/// [renderLibrary] will use this template.
///
/// The template is expected to be able to handle the following data structure
/// which mirrors the contents of a class declaration.
///
///     {
///       "declaration": "class Foo"  // String containing the class declaration
///       "sections": [
///         {
///           "name": "...",          // The name of the section
///           "source": "..."         // Source code for the section
///         },
///         ...
///       ]
///     }
void classTemplateSource(String source) {
  _template = new Template(source);
}

/// Renders the class definition with the given [values].
String renderClass(Map values) => _template.renderString(values);
