// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.src.codegen.routes_generator;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import '../../metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Class name for a UrlTemplate.
const String _uriTemplate = 'UriTemplate';
/// Variable name for the base url.
const String _baseUrl = 'baseUrl';
/// Class name for the routes.
const String _routesClass = 'Map<String, $_uriTemplate>';
/// Variable name for the routes.
const String _routesMap = 'values';

/// Writes out the names of the [routes] as constants that can be referenced into the [buffer].
void generateTables(List<RouteMetadata> routes, StringBuffer buffer) {
  var count = routes.length;

  for (var i = 0; i < count; ++i) {
    buffer.writeln('const String ${routes[i].name} = \'$i\';');
  }
}

void generateRoutes(List<RouteMetadata> routes, StringBuffer buffer) {
  _generateRoutes(routes, buffer);
}

void _generateRoutes(List<RouteMetadata> routes, StringBuffer buffer) {
  buffer.writeln('$_routesClass _routes(String $_baseUrl) {');
  buffer.writeln('var $_routesMap = new $_routesClass();\n');

  for (var route in routes) {
    buffer.writeln('$_routesMap[${route.name}] = new $_uriTemplate(\'\$$_baseUrl${route.path}\');');
  }

  buffer.writeln('\nreturn $_routesMap;');
  buffer.writeln('}');
}
