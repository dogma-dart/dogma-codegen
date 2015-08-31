// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains functions for controlling logging within the library.
library dogma_codegen.src.build.logging;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:logging/logging.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Initializes logging for the code generation.
void initializeLogging([Level level = Level.INFO]) {
  Logger.root.level = level;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}
