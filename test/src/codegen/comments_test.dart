// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:test/test.dart';

import 'package:dogma_codegen/codegen.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// A long line of text
const String _longLineOfTest =
r'''Here's a line of text that should end up taking up multiple lines when busted up into parts.''';
const String _overrunWord =
r'''Single 000000000000000000000000000000000000000000000000000000000000000000000000000000000''';
/// A markdown comment
const String _markdownComment =
r'''    Here's a really long markdown comment that should end up using a single line even though its over the count.
    Here's a really long markdown comment that should end up using a single line even though its over the count.
    Here's a really long markdown comment that should end up using a single line even though its over the count.''';

List<String> _commentLines(String comment) {
  var buffer = new StringBuffer();

  generateCodeComment(comment, buffer);

  var value = buffer.toString().trimRight();

  return value.split('\n');
}

/// Test entry point.
void main() {
  test('Line breaks inserted', () {
    var lines = _commentLines(_longLineOfTest);

    expect(lines, hasLength(2));
    expect(lines[0].endsWith('when'), isTrue);
    expect(lines[1].startsWith('/// busted'), isTrue);
  });
  test('Allow overrun', () {
    var lines = _commentLines(_overrunWord);

    expect(lines, hasLength(2));
    expect(lines[0].endsWith('Single'), isTrue);
    expect(lines[1].length, greaterThan(80));
  });
  test('Markdown comments', () {
    var lines = _commentLines(_markdownComment);

    expect(lines, hasLength(3));
  });
}
