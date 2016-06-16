// Copyright (c) 2016, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:convert';

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_convert/convert.dart';

import '../../build.dart';
import 'formatter_config_convert.dart';
import 'target_config_convert.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Decoder for a [BuilderConfig].
class BuilderConfigDecoder<T extends TargetConfig> extends Converter<Map, BuilderConfig<T>>
                           implements ModelDecoder<BuilderConfig<T>> {
  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// The key for the library output.
  static const String libraryOutputKey = 'output_directory';
  /// The key for the copyright information.
  static const String copyrightKey = 'copyright';
  /// The key for whether library directive should be outputted.
  static const String outputLibraryDirectiveKey = 'output_library_directive';
  /// The key for whether build timestamps should be outputted.
  static const String outputBuildTimestampsKey = 'output_build_timestamps';
  /// The key for the formatter values.
  static const String formatterKey = 'formatter';
  /// The key for the target values.
  static const String targetsKey = 'targets';

  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// The [FormatterConfig] decoder to use.
  final ModelDecoder<FormatterConfig> formatterConfigDecoder;
  /// The [TargetConfig] decoder to use.
  final ModelDecoder<TargetConfig> targetConfigDecoder;

  //---------------------------------------------------------------------
  // Constructor
  //---------------------------------------------------------------------

  /// Creates an instance of [FormatterConfigDecoder].
  const BuilderConfigDecoder({this.formatterConfigDecoder: const FormatterConfigDecoder(),
                              this.targetConfigDecoder: const TargetConfigDecoder()});

  //---------------------------------------------------------------------
  // ModelDecoder
  //---------------------------------------------------------------------

  @override
  BuilderConfig<T> create() => new BuilderConfig() as BuilderConfig<T>;

  @override
  BuilderConfig<T> convert(Map input, [BuilderConfig<T> model]) {
    model ??= create();

    model.libraryOutput = input[libraryOutputKey];
    model.copyright = input[copyrightKey];
    model.outputLibraryDirective = input[outputLibraryDirectiveKey];
    model.outputBuildTimestamps = input[outputBuildTimestampsKey];

    model.formatterConfig =
        formatterConfigDecoder.convert(input[formatterKey], model.formatterConfig);

    var targets = <String, TargetConfig>{};

    input[targetsKey].forEach((key, value) {
      targets[key] = targetConfigDecoder.convert(value);
    });

    return model;
  }
}
