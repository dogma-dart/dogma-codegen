// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains functions for getting an analysis context.
library dogma_codegen.src.analyzer.context;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:analyzer/file_system/file_system.dart' hide File;
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer/src/generated/engine.dart';
import 'package:analyzer/src/generated/java_io.dart';
import 'package:analyzer/src/generated/sdk_io.dart' show DirectoryBasedDartSdk;
import 'package:analyzer/src/generated/source.dart';
import 'package:analyzer/src/generated/source_io.dart';
import 'package:path/path.dart' as path;

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Creates an analysis context for a project.
///
/// The [projectPath] refers to the root of the repository. The [sdkPath]
/// points to the installed location of the Dart SDK.
AnalysisContext analysisContext(String projectPath, String sdkPath) {
  // Setup the core dart libraries
  JavaSystemIO.setProperty('com.google.dart.sdk', sdkPath);
  var sdk = DirectoryBasedDartSdk.defaultSdk;

  // Get the packages directory
  var packages = new JavaFile(path.join(projectPath, 'packages'));

  // Create the resolvers
  var resolvers = [
      new DartUriResolver(sdk),
      new ResourceUriResolver(PhysicalResourceProvider.INSTANCE),
      new PackageUriResolver([packages])
  ];

  // Set the analysis options
  var options = new AnalysisOptionsImpl()
      ..cacheSize = 256
      ..preserveComments = true
      ..analyzeFunctionBodies = false;

  // Return the context
  return AnalysisEngine.instance.createAnalysisContext()
      ..analysisOptions = options
      ..sourceFactory = new SourceFactory(resolvers);
}
