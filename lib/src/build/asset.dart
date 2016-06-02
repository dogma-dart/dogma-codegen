// Copyright (c) 2016, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:build/build.dart';
import 'package:dogma_source_analyzer/path.dart' as p;

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// The current package graph.
///
/// This will be the package running the codegen process.
final PackageGraph currentPackageGraph = new PackageGraph.forThisPackage();

/// The current package name.
final String currentPackageName = currentPackageGraph.root.name;

/// Creates an asset id based on the [uri].
///
/// This assumes that the [uri] is within the current package.
AssetId rootAssetIdFromUri(Uri uri) {
  var path = p.relative(uri);

  return new AssetId(currentPackageName, path);
}
