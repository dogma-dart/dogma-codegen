// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [ArgumentBuffer] class.
library dogma_codegen.src.codegen.argument_buffer;

class ArgumentBuffer {
  /// The separator to use.
  final String separator;
  /// The string buffer to write to.
  StringBuffer _buffer = new StringBuffer();
  /// Whether the separator should be used.
  bool _useSeparator = false;

  ArgumentBuffer([this.separator = ',']);

  ArgumentBuffer.lineBreak()
      : separator = ',\n';

  void write(String value) {
    if (_useSeparator) {
      _buffer.write(separator);
    } else {
      _useSeparator = true;
    }

    _buffer.write(value);
  }

  @override
  String toString() => _buffer.toString();
}
