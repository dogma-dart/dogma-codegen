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

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// The name of the flag that designates the build was triggered automatically.
const String _machine = 'machine';
/// The name of the option containing a list of changed files.
const String _changed = 'changed';
/// The name of the option containing a list of removed files.
const String _removed = 'removed';

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
      ..addOption(_changed, allowMultiple: true)
      ..addOption(_removed, allowMultiple: true);

  var parsed = parser.parse(args);

  // Rebuild everything if build was invoked directly
  if (!parsed[_machine]) {
    return true;
  }

  // Iterate through the changed files and see which ones were manually created
  var notGenerated = [];

  for (var changed in parsed[_changed]) {
    print(changed);
  }

  // Nothing was found to trigger the build
  return false;
}