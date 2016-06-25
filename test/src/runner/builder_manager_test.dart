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

import 'package:build/build.dart';
import 'package:dogma_codegen/view.dart';
import 'package:dogma_convert/convert.dart';
import 'package:dogma_source_analyzer/metadata.dart';
import 'package:test/test.dart';

import 'package:dogma_codegen/build.dart';
import 'package:dogma_codegen/runner.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

class _BuilderTestConfig extends TargetConfig {
  String test;
}

// ignore: unused_element
class _BuilderTestConfigDecoder extends Converter<Map, _BuilderTestConfig>
                             implements ModelDecoder<_BuilderTestConfig> {
  final ModelDecoder<BuilderConfig> builderConfigDecoder;

  const _BuilderTestConfigDecoder()
      : builderConfigDecoder = const BuilderConfigDecoder();

  @override
  _BuilderTestConfig create() => new _BuilderTestConfig();

  @override
  _BuilderTestConfig convert(Map input, [_BuilderTestConfig model]) {
    model ??= create();

    model.test = input['test'];

    return model;
  }
}

@RegisterBuilder('test')
// ignore: unused_element
class _BuilderTest extends SourceBuilder<_BuilderTestConfig> {
  _BuilderTest(BuilderConfig<_BuilderTestConfig> config)
      : super(config);

  @override
  Future<LibraryMetadata> metadata(BuildStep step) async => null;

  @override
  MetadataView<LibraryMetadata> view(LibraryMetadata metadata) => null;

  @override
  MetadataView<LibraryMetadata> viewGeneration(MetadataView<LibraryMetadata> source) => null;

  @override
  String sourceCode(MetadataView<LibraryMetadata> source) => '';
}

/// Test entry point.
void main() {
  test('Registration', () {
    var manager = new BuilderManager();

    expect(manager.hasBuilder('foo'), isFalse);
    expect(manager.hasBuilder('test'), isFalse);

    manager.autoRegisterBuilders();

    expect(manager.hasBuilder('foo'), isFalse);
    expect(manager.hasBuilder('test'), isTrue);

    var input = {
      'output_directory': '',
      'copyright': '',
      'output_library_name': '',
      'output_build_timestamps': false,
      'targets': {},
      'formatter': {
        'line_ending': '\n',
        'page_width': 80,
        'indent': 0
      },
      'defaults': {
        'test': 'success'
      }
    };

    var builder = manager.createBuilder('test', input);

    expect(builder is _BuilderTest, isTrue);
    expect(builder.config is BuilderConfig, isTrue);
    expect(builder.config.defaultTarget is _BuilderTestConfig, isTrue);

    var config = builder.config.defaultTarget as _BuilderTestConfig;
    var defaults = input['defaults'] as Map;

    expect(config.test, defaults['test']);
  });
}
