// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains functions for triggering builds using the build_system library.
library dogma_codegen.src.build.build_system;

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:async';

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:args/args.dart';
import 'package:logging/logging.dart';

import 'package:dogma_codegen/path.dart' as p;

import 'io.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// The name of the flag that designates the build was triggered automatically.
const String _machine = 'machine';
/// The name of the flag requesting a full rebuild.
const String _full = 'full';
/// The name of the option containing a list of changed files.
const String _changed = 'changed';
/// The name of the option containing a list of removed files.
const String _removed = 'removed';

/// The logger for the library.
final Logger _logger = new Logger('dogma_codegen.src.build.build_system');

/// Determines whether a build should be triggered.
///
/// Parses the values in [args] according to the arguments generated from the
/// [build_system](https://github.com/a14n/build_system.dart) library. The
/// library looks for changes to the file system within the package's
/// directory and then invokes the build.dart file within the package. To
/// signify that it is the caller it uses the 'machine' flag. If this flag is
/// present then the changed files are looked at to determine if a build should
/// happen. If [args] does not contain the flag it is assumed that a full
/// build is being requested.
///
/// The [paths] value contains a list of files or directories that should be
/// watched for changes. If the any changes occur within those values that are
/// not generated files then a build will trigger.
///
/// Currently the removed option is ignored.
Future<bool> shouldBuild(List<String> args, List<String> paths) async {
  // Parse the arguments
  var parser = new ArgParser()
      ..addFlag(_machine, defaultsTo: false)
      ..addFlag(_full, defaultsTo: false)
      ..addOption(_changed, allowMultiple: true)
      ..addOption(_removed, allowMultiple: true);

  var parsed = parser.parse(args);

  // Rebuild everything if build was invoked directly
  if (!parsed[_machine] || parsed[_full]) {
    _logger.info('Rebuild requested');
    return true;
  }

  // Iterate through the changed files and see which ones were manually created
  for (var changed in parsed[_changed]) {
    _logger.info('File changed $changed');

    // See if the file was manually created
    var filePath = p.join(changed);

    if (!await isGeneratedFile(filePath)) {
      _logger.fine('File is not generated');

      for (var watched in paths) {
        var watchedPath = p.join(watched);

        if ((filePath == watchedPath) || (p.isWithin(watchedPath, filePath))) {
          return true;
        }
      }

      _logger.fine('File change does not trigger a build');
    } else {
      _logger.fine('File is generated, ignoring');
    }
  }

  return false;
}
