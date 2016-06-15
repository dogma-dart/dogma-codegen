// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_source_analyzer/metadata.dart';
import 'package:dogma_source_analyzer/path.dart';
import 'package:test/test.dart';

import 'package:dogma_codegen/codegen.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

const String _htmlPrefix = 'html';
final List<String> _htmlShownNames = <String>['Element', 'Console'];
final List<String> _htmlHiddenNames = <String>['Body', 'document'];
final LibraryMetadata _dartHtml = new LibraryMetadata(Uri.parse('dart:html'));
final UriReferencedMetadata _dartHtmlReference =
    new UriReferencedMetadata.withLibrary(_dartHtml);
final UriReferencedMetadata _dartHtmlReferenceWithPrefix =
    new UriReferencedMetadata.withLibrary(_dartHtml, prefix: _htmlPrefix);
final UriReferencedMetadata _dartHtmlReferenceWithPrefixShown =
    new UriReferencedMetadata.withLibrary(
        _dartHtml,
        prefix: _htmlPrefix,
        shownNames: _htmlShownNames
    );
final UriReferencedMetadata _dartHtmlReferenceWithPrefixHidden =
    new UriReferencedMetadata.withLibrary(
        _dartHtml,
        prefix: _htmlPrefix,
        hiddenNames: _htmlHiddenNames
    );
final Uri _fromLib = join('lib/a.dart');

void _expectImportDirective(UriReferencedMetadata metadata,
                         Uri from,
                         String expected) {
  var buffer = new StringBuffer();

  generateUriReference(metadata, from, 'import', buffer);

  var actual = buffer.toString();

  expect(actual, equalsIgnoringWhitespace(expected));
}

/// Test entry point.
void main() {
  test('references', () {
    var importHtml = 'import \'dart:html\'';

    _expectImportDirective(
        _dartHtmlReference,
        _fromLib,
        '$importHtml;'
    );
    _expectImportDirective(
        _dartHtmlReferenceWithPrefix,
        _fromLib,
        '$importHtml as $_htmlPrefix;'
    );
    _expectImportDirective(
        _dartHtmlReferenceWithPrefixShown,
        _fromLib,
        '$importHtml as $_htmlPrefix show ${_htmlShownNames.join(',')};'
    );
    _expectImportDirective(
        _dartHtmlReferenceWithPrefixHidden,
        _fromLib,
        '$importHtml as $_htmlPrefix hide ${_htmlHiddenNames.join(',')};'
    );
  });
}
