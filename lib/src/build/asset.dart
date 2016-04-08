
import 'package:build/build.dart';
import 'package:dogma_source_analyzer/path.dart' as p;

final String currentPackageName = new PackageGraph.forThisPackage().root.name;

AssetId rootAssetIdFromUri(Uri uri) {
  var path = p.relative(uri);

  return new AssetId(currentPackageName, path);
}
