// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains metadata for the ColorImplicit enumeration and library.
///
/// This tests enumerations with implicit serialization.
library dogma_codegen.test.src.build.enum_implicit_library;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';
import 'package:dogma_codegen/path.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Gets a library containing the ColorImplicit enumeration.
LibraryMetadata enumImplicitLibrary() =>
    new LibraryMetadata(
        'dogma_codegen.test.libs.src.models.color_implicit',
        join('test/libs/src/models/color_implicit.dart'),
        enumerations: [enumImplicitMetadata()]);

/// Metadata for the ColorImplicit enumeration.
EnumMetadata enumImplicitMetadata() =>
    new EnumMetadata('ColorImplicit', ['red', 'green', 'blue']);
