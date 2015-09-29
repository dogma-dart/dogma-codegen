// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains metadata for the ColorExplicit enumeration and library.
library dogma_codegen.test.src.build.enum_explicit_library;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';
import 'package:dogma_codegen/path.dart';
import 'package:dogma_codegen/src/build/libraries.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Gets a library containing the ColorExplicit enumeration.
LibraryMetadata enumExplicitLibrary() =>
    new LibraryMetadata(
        'dogma_codegen.test.libs.src.models.color_explicit',
        join('test/libs/src/models/color_explicit.dart'),
        imported: [dogmaSerialize],
        enumerations: [enumExplicitMetadata()]);

/// Metadata for the ColorExplicit enumeration.
EnumMetadata enumExplicitMetadata() =>
    new EnumMetadata(
        'ColorExplicit',
        ['red', 'green', 'blue'],
        encoded: [0xff0000, 0x00ff00, 0x0000ff]);
