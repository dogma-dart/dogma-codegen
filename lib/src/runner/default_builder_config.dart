// Copyright (c) 2016, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'builder_config.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Default configuration to use for a builder.
class DefaultBuilderConfig implements BuilderConfig {
  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// The package containing the input set.
  final String inputPackage;
  /// The set of inputs for the build step.
  final List<String> inputSet;
  /// The root library to output to.
  final String outputLibrary;

  @override
  final String outputDirectory;

  //---------------------------------------------------------------------
  // Constructors
  //---------------------------------------------------------------------

  /// Creates an instance of the [DefaultBuilderConfig] with the given [name]
  /// from the configuration [values].
  ///
  /// The [name] is used to provide default values for the outputs. A [previous]
  /// build step can be passed into the constructor to determine the set of
  /// inputs.
  factory DefaultBuilderConfig(String name, Map values, [BuilderConfig previous]) {
    var inputPackage = values['input_package'] ?? '';

    // Get the input set
    var inputSet = values['input_set'] as List<String>;

    if (inputSet == null) {
      if (previous == null) {
        throw new ArgumentError('Unable to determine input set');
      }

      inputSet = <String>['${previous.outputDirectory}*.dart'];
    }

    // Get the root library
    var shouldOutputLibrary = values['should_output_library'] ?? true;
    var outputLibrary = '';

    if (shouldOutputLibrary) {
      outputLibrary = values['output_library'] ?? 'lib/$name.dart';
    }

    // Get the output directory
    var outputDirectory = values['output_directory'] ?? 'lib/src/$name';

    return new DefaultBuilderConfig._(
        inputPackage,
        inputSet,
        outputLibrary,
        outputDirectory
    );
  }

  /// Creates an instance of the [DefaultBuilderConfig].
  DefaultBuilderConfig._(this.inputPackage,
                         this.inputSet,
                         this.outputLibrary,
                         this.outputDirectory);
}
