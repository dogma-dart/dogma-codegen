// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [ArgumentBuffer] class.
library dogma_codegen.src.codegen.argument_buffer;

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// A wrapper over a string buffer that handles writing a list of arguments.
///
/// The [ArgumentBuffer] keeps track of the number of times [write] was called
/// and writes the [separator] during successive calls.
class ArgumentBuffer {
  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// The separator to use.
  final String separator;
  /// The string buffer to write to.
  final StringBuffer _buffer = new StringBuffer();

  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Creates an instance of the [ArgumentBuffer] class.
  ///
  /// If no separator is specified then ',' is used.
  ArgumentBuffer([this.separator = ',']);

  /// Creates an instance of the [ArgumentBuffer] class where arguments are
  /// separated using a ',' and a line break.
  ArgumentBuffer.lineBreak()
      : separator = ',\n';

  //---------------------------------------------------------------------
  // Public methods
  //---------------------------------------------------------------------

  /// Writes the argument [value] to the buffer.
  void write(String value) {
    // Write the separator if the buffer is not empty
    if (_buffer.isNotEmpty) {
      _buffer.write(separator);
    }

    _buffer.write(value);
  }

  /// Writes a list of [values] to the buffer.
  void writeAll(List<String> values) {
    for (var value in values) {
      write(value);
    }
  }

  /// Returns the contents of the buffer.
  @override
  String toString() => _buffer.toString();
}
