// Copyright (c) 2015-2016 the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:async';
import 'dart:convert';

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:test/test.dart';

import 'package:dogma_codegen/schema.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

const String _id = 'id';
const String _properties = 'properties';
const int _schemaCount = 10;

/// The number of function calls to _loadReference
int _functionCalls = 0;

Map _createMap(String reference) => {_id: reference, _properties: {}};
String _propertyReference(String reference) =>
   '$reference$rootScope$_properties';

Future<dynamic> _loadReference(String reference) async {
  ++_functionCalls;
  return _createMap(reference);
}

/// Test entry point.
void main() {
  test('Schema loading', () async {
    var value;

    // Create the root schema
    var root = _createMap('root');
    var schema = createRootSchema(root);

    // Load the root schema
    value = await getReference(schema, '', _loadReference);
    expect(value, root);

    // Load the properties in the root schema
    value = await getReference(schema, '#properties', _loadReference);
    expect(value, {});

    var i = 0;
    _functionCalls = 0;

    // Test for schema loading
    var getSchemas = () async {
      var reference = i.toString();
      var expected = _createMap(reference);

      value = await getReference(schema, reference, _loadReference);
      expect(value, expected);

      value = await getReference(schema, _propertyReference(reference), _loadReference);
      expect(value, expected[_properties]);
    };

    // Load a bunch of schemas
    while (i < _schemaCount) {
      await getSchemas();

      ++i;
      expect(_functionCalls, i);
    }

    // Load the schemas again
    i = 0;
    _functionCalls = 0;

    while (i < _schemaCount) {
      await getSchemas();

      ++i;
      expect(_functionCalls, 0);
    }
  });
  test('Nested schema up', () async {
    // Create the root schema
    var root = _createMap('root');
    var schema = createRootSchema(root);

    // Create a schema going up
    var path = '';
    _functionCalls = 0;

    for (var i = 0; i < _schemaCount; ++i) {
      var reference = path + 'a';
      var value = await getReference(schema, reference, _loadReference);
      expect(value[_id], reference);

      path = '../' + path;
    }

    expect(_functionCalls, _schemaCount);

    // Check the schemas from different paths
    _functionCalls = 0;
    path = '';

    // Get the schemas
    for (var i = 0; i < _schemaCount; ++i) {
      var relativePath = '';

      for (var j = i; j < _schemaCount; ++j) {
        var reference = relativePath + 'a';
        var value = await getReference(schema, reference, _loadReference, path);
        expect(value[_id], path + reference);

        relativePath = '../' + relativePath;
      }

      path = '../' + path;
    }

    expect(_functionCalls, 0);
  });
  test('Schema path', () async {
    var rootPath = 'root/';
    var commonPath = 'common/';
    var specPath = 'spec/';
    var specAName = 'specA';
    var specBName = 'specB';
    var commonAName = 'commonA';
    var value;

    // Create the schema values in spec
    var specA = _createMap(specAName);
    var schema = createRootSchema(specA, rootPath + specPath + specAName);
    var specB = await getReference(schema, rootPath + specPath + specBName, _loadReference);

    // Create the common value relative to spec
    var commonA = await getReference(
        schema,
        '../' + commonPath + commonAName,
        _loadReference,
        rootPath + specPath
    );

    // Test getting the values of spec from common
    value = await getReference(
        schema,
        '../' + specPath + specAName,
        _loadReference,
        rootPath + commonPath
    );
    expect(value, specA);

    value = await getReference(
        schema,
        '../' + specPath + specBName,
        _loadReference,
        rootPath + commonPath
    );
    expect(value, specB);

    // Test getting the value of common from the root
    value = await getReference(schema, rootPath + commonPath + commonAName, _loadReference);
    expect(value, commonA);

    print(JSON.encode(schema));
  });
}
