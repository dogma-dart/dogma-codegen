// Copyright (c) 2015-2016 the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Prefix for code comments.
const String _commentPrefix = '/// ';
/// Prefix for markdown comments
const String _markdownIndent = '    ';
/// Space character.
const String _space = ' ';

/// Generates a code documentation [comment] into the buffer.
///
/// The code generation will generate comments that will fit in the given
/// [lineLength] based on the size of the comment prefix and the value of
/// [indentBy].
///
/// A line can overrun [lineLength] if a single word will not fit on the line,
/// which could be the case for links in Markdown format, or if it is a code
/// comment which is prefixed by 4 spaces in Markdown.
void generateCodeComment(String comment,
                         StringBuffer buffer,
                        [int indentBy = 0,
                         int lineLength = 80]) {
  // See if there's anything to write
  if (comment.isEmpty) {
    return;
  }

  // Split the comments into lines
  var split = comment.split('\n');

  // Get the maximum length of a line in the comments
  var length = lineLength - indentBy -_commentPrefix.length;

  // Iterate through the values
  for (var value in split) {
    var trimmed = false;

    // Any lines of text should be broken up unless they're markdown comments
    if (!value.startsWith(_markdownIndent)) {
      while (value.length > lineLength) {
        var i = length - 1;
        var foundSpace = value[i] == _space;

        // Find the last word
        for (i = length - 1; i >= 0; --i) {
          var isSpace = value[i] == _space;

          if ((foundSpace) && (!isSpace)) {
            ++i;
            break;
          } else if (isSpace) {
            foundSpace = true;
          }
        }

        // Check if the entire line is too long to display within the space
        if (i < 0) {
          var valueLength = value.length;

          // Find the next word
          for (i = length; i < valueLength; ++i) {
            if (value[i] == _space) {
              break;
            }
          }

          i = i > valueLength ? valueLength : i;
        }

        // Split the value
        buffer.write(_commentPrefix);
        buffer.writeln(value.substring(0, i).trimRight());
        value = value.substring(i).trimLeft();

        trimmed = true;
      }
    }

    // Only write a blank line if it was present in the original string
    if ((!trimmed) || (value.isNotEmpty)) {
      buffer.write(_commentPrefix);
      buffer.writeln(value);
    }
  }
}
