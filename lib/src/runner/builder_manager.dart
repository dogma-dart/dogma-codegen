// Copyright (c) 2016, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Standard libraries
//---------------------------------------------------------------------

import 'dart:mirrors';

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_convert/convert.dart';

import '../../build.dart';
import 'register_builder.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// A function that creates a [SourceBuilder] from the [input] config.
typedef SourceBuilder BuilderCreator(Map input);

/// Handles the registration of builders to perform build steps.
///
/// The [BuilderManager] allows implementations of SourceBuilder to register
/// themselves with the manager so they can be instantiated. This can either
/// be done explicitly or automatically using the [autoRegisterBuilders]
/// method, which uses reflection to find any implementations of SourceBuilder
/// and BuilderConfig that were imported into the executable.
///
/// From there a the configuration can be used to create the build steps which
/// will then be used by the build library.
class BuilderManager {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// A symbol for the default constructor.
  static const Symbol _defaultConstructor = const Symbol('');

  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// Contains the registered config creators.
  final Map<String, BuilderCreator> _builderCreators = <String, BuilderCreator>{};

  //---------------------------------------------------------------------
  // Public methods
  //---------------------------------------------------------------------

  /// Attempts to register builders that were imported into the build script.
  ///
  /// This uses reflection to attempt to find any libraries that may contain
  /// implementations of [SourceBuilder]. If the builder contains a
  /// [RegisterBuilder] annotation it will be registered with the builder.
  void autoRegisterBuilders() {
    var mirrorSystem = currentMirrorSystem();

    // Get the build library
    var buildLibrary = mirrorSystem.findLibrary(#dogma_codegen.build);

    if (buildLibrary == null) {
      throw new ArgumentError('The dogma_codegen.build library was not found');
    }

    var convertLibrary = mirrorSystem.findLibrary(#dogma_convert.convert);

    if (convertLibrary == null) {
      throw new ArgumentError('The dogma_convert.convert library was not found');
    }

    // Find the required mirrors
    var builderMirror = _findClass(buildLibrary, #SourceBuilder);
    var configMirror = _findClass(buildLibrary, #BuilderConfig);
    var decoderMirror = _findClass(convertLibrary, #ModelDecoder);

    // If this is null then something went really wrong
    assert(builderMirror != null);
    assert(configMirror != null);

    // Find all implementations of SourceBuilder
    var builders = _findSubclasses(buildLibrary, builderMirror);
    var decoders = _findSubclasses(convertLibrary, decoderMirror);

    // Register all builders
    for (var builder in builders) {
      var register;

      for (var annotation in builder.metadata) {
        var reflectee = annotation.reflectee;

        if (reflectee is RegisterBuilder) {
          register = reflectee;

          break;
        }
      }

      if (register != null) {
        var registerAs = register.name;

        var constructor = builder.declarations[builder.simpleName] as MethodMirror;
        var parameters = constructor.parameters;

        // Verify the signature of the default constructor
        if (parameters.length == 1) {
          var configParameter = parameters[0];

          if (configParameter.type.isSubtypeOf(configMirror)) {
            var modelDecoder;

            // Find the decoder for the type
            for (var decoder in decoders) {
              var modelMirror = decoder.superinterfaces.firstWhere(
                  (interface) => interface.isSubclassOf(decoderMirror)
              ).typeArguments[0];

              if (modelMirror.isSubtypeOf(configParameter.type)) {
                modelDecoder = decoder;

                break;
              }
            }

            if (modelDecoder != null) {
              registerBuilderCreator(
                  registerAs,
                  _defaultBuilderCreator(builder, modelDecoder)
              );
            } else {
              print('Could not find decoder');
            }
          } else {
            print('Unknown config type');
          }
        } else {
          print('Could not register');
        }
      } else {
        print('Unknown');
      }
    }
  }

  /// Registers a [creator] function for the given [name].
  ///
  /// This function should only be called when manually registering a builder.
  /// Builders found through [autoRegisterBuilders] will be added through this
  /// method.
  void registerBuilderCreator(String name, BuilderCreator creator) {
    if (_builderCreators[name] != null) {
      throw new ArgumentError.value(name, 'A builder with that name has already been registered');
    }

    _builderCreators[name] = creator;
  }

  /// Checks whether a builder is registered with the [name].
  bool hasBuilder(String name) => _builderCreators.containsKey(name);

  /// Creates a builder registered with the [name] using the given [config].
  SourceBuilder createBuilder(String name, Map config) {
    var creator = _builderCreators[name];

    if (creator == null) {
      throw new ArgumentError.value(name, 'A builder with the name is not registered');
    }

    return creator(config);
  }

  //---------------------------------------------------------------------
  // Private methods
  //---------------------------------------------------------------------

  /// Searches a root [library] for a class with the given [name].
  ///
  /// This is meant to search the exports of a root library.
  static ClassMirror _findClass(LibraryMirror library, Symbol name) {
    var mirror;

    for (var dependency in library.libraryDependencies) {
      if (dependency.isExport) {
        mirror = dependency.targetLibrary.declarations[name];

        if (mirror != null) {
          break;
        }
      }
    }

    return mirror;
  }

  /// Finds any implementations of the [baseClass] in the current application.
  ///
  /// The [import] library is used to narrow down what libraries should be
  /// searched through.
  static List<ClassMirror> _findSubclasses(LibraryMirror import,
                                           ClassMirror baseClass) {
    var libraries = currentMirrorSystem().libraries.values;
    var importsBuild = libraries.where((mirror) {
      for (var dependency in mirror.libraryDependencies) {
        if (dependency.targetLibrary == import) {
          return true;
        }
      }

      return false;
    });

    // Find all implementations of SourceBuilder
    var classes = <ClassMirror>[];

    for (var library in importsBuild) {
      var declarations = library.declarations.values;

      for (var declaration in declarations) {
        if (declaration is ClassMirror) {
          // See if the declaration is a subclass
          if (declaration.isSubclassOf(baseClass)) {
            classes.add(declaration);

            break;
          }

          // See if any of the interfaces is a subclass
          for (var interface in declaration.superinterfaces) {
            if (interface.isSubclassOf(baseClass)) {
              classes.add(declaration);

              break;
            }
          }
        }
      }
    }

    return classes;
  }

  /// Creates a new [ModelDecoder] by instantiating a new object through the
  /// class [mirror].
  static ModelDecoder _createModelDecoder(ClassMirror mirror) =>
      mirror.newInstance(_defaultConstructor, [])
          .reflectee as ModelDecoder;

  /// Creates a new [SourceBuilder] by instantiating a new object through the
  /// class [mirror] and the [config].
  static SourceBuilder _createSourceBuilder(ClassMirror mirror,
                                            BuilderConfig config) =>
      mirror.newInstance(_defaultConstructor, [config])
          .reflectee as SourceBuilder;

  /// Creates a function which uses the [builderMirror] and [decoderMirror]
  /// to instantiate a [SourceBuilder].
  static BuilderCreator _defaultBuilderCreator(ClassMirror builderMirror,
                                               ClassMirror decoderMirror) {
    var decoder = _createModelDecoder(decoderMirror);

    return (input) {
      var config = decoder.convert(input) as BuilderConfig;

      return _createSourceBuilder(builderMirror, config);
    };
  }
}
