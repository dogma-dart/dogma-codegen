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
AssetId rootAssetIdFromUri(Uri uri) =>
    rootAssetFromRelativePath(p.relative(uri));

/// Creates an asset id based on the relative [path].
AssetId rootAssetFromRelativePath(String path) =>
    new AssetId(currentPackageName, path);

/// Transforms the [input] asset Uri into a package or file Uri.
///
/// When using `build` the source code Uris are in the form
/// `asset:package_name/path`. This function will convert it to a Uri that can
/// be used within a library metadata.
Uri assetUriTransform(Uri input) {
  if (input.scheme != 'asset') {
    return input;
  }

  var pathSegments = input.pathSegments;
  var package = pathSegments[0];
  var path = pathSegments.sublist(1).join('/');

  return _assetUri(package, path);
}

/// Gets the Uri from the [input] asset id.
Uri assetIdUri(AssetId input) => _assetUri(input.package, input.path);

/// Converts the [package] and [path] into a Uri.
///
/// If the [package] is equal to the current package name a File Uri will be
/// returned; otherwise a package Uri will be returned.
Uri _assetUri(String package, String path) =>
    (package == currentPackageName)
        ? p.join(path)
        : p.join(path, base: Uri.parse('package:$package'));
