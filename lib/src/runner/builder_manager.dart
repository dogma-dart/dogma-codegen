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
import 'package:logging/logging.dart';

import '../../build.dart';
import 'register_builder.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// A function that creates a [SourceBuilder] from the [input] config.
typedef SourceBuilder BuilderCreator(Map input);

/// The logger for the library.
final Logger _logger =
    new Logger('dogma_codegen.src.runner.builder_manager');

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
      _logger.severe('The dogma_codgen.build library was not found');
      throw new ArgumentError('The dogma_codegen.build library was not found');
    }

    var convertLibrary = mirrorSystem.findLibrary(#dogma_convert.convert);

    if (convertLibrary == null) {
      _logger.severe('The dogma_convert.convert library was not found');
      throw new ArgumentError('The dogma_convert.convert library was not found');
    }

    // Find the required mirrors
    var builderMirror = _findClass(buildLibrary, #SourceBuilder);
    var configurableMirror = _findClass(buildLibrary, #Configurable);
    var builderConfigMirror = _findClass(buildLibrary, #BuilderConfig);
    var targetConfigMirror = _findClass(buildLibrary, #TargetConfig);
    var decoderMirror = _findClass(convertLibrary, #ModelDecoder);

    // If this is null then something went really wrong
    assert(builderMirror != null);
    assert(configurableMirror != null);
    assert(builderConfigMirror != null);
    assert(targetConfigMirror != null);
    assert(decoderMirror != null);

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

        _logger.info('Attempting to register ${builder.simpleName} as $registerAs');

        var constructor = builder.declarations[builder.simpleName] as MethodMirror;
        var parameters = constructor.parameters;

        // Verify the signature of the default constructor
        if (parameters.length == 1) {
          var configMirror = parameters[0].type as ClassMirror;

          _logger.fine('Found parameter ${configMirror.simpleName}');

          if (configMirror.isSubclassOf(builderConfigMirror)) {
            // Find the decoder for the builder config type
            var configDecoderMirror = _findDecoder(
                configMirror,
                decoderMirror,
                decoders
            );

            if (configDecoderMirror != null) {
              _logger.fine('Found decoder ${configDecoderMirror.simpleName} of type ${configMirror.simpleName}');

              // Get the generic type for the builder config
              var configTypeArguments = configMirror.typeArguments;
              var targetMirror = configTypeArguments.length == 1
                  ? configTypeArguments[0] as ClassMirror
                  : null;

              if ((targetMirror != null) && (targetMirror.isSubclassOf(targetConfigMirror))) {
                // Find the decoder for the target config type
                var targetDecoderMirror = _findDecoder(
                    targetMirror,
                    decoderMirror,
                    decoders
                );

                if (targetDecoderMirror != null) {
                  _logger.fine('Found decoder ${targetDecoderMirror.simpleName} of type ${targetMirror.simpleName}');
                  _logger.info('Registering ${builder.simpleName}');

                  registerBuilderCreator(
                      registerAs,
                      _defaultBuilderCreator(
                          builder,
                          configDecoderMirror,
                          targetDecoderMirror
                      )
                  );
                } else {
                  _logger.warning('Could not find decoder for ${targetMirror.simpleName}');
                }
              } else {
                _logger.warning('No target config type specified for ${configMirror.simpleName}');
              }
            } else {
              _logger.warning('Could not find decoder for ${configMirror.simpleName}');
            }
          } else {
            _logger.warning('Unknown config type for ${builder.simpleName} ${configMirror.simpleName}');
          }
        } else {
          _logger.warning('Default constructor for ${builder.simpleName} does not match expected signature; unable to register');
        }
      } else {
        _logger.warning('${builder.simpleName} has no registration');
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
          _logger.fine('Found library to search ${mirror.simpleName} at ${mirror.uri}');
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
          _logger.fine('Found class ${declaration.simpleName}');

          // See if the declaration is a subclass
          if (declaration.isSubclassOf(baseClass)) {
            classes.add(declaration);

            _logger.info('Class ${declaration.simpleName} is a subclass of ${baseClass.simpleName}');

            break;
          }

          // See if any of the interfaces is a subclass
          for (var interface in declaration.superinterfaces) {
            if (interface.isSubclassOf(baseClass)) {
              classes.add(declaration);

              _logger.info('Class ${declaration.simpleName} has a superinterface of ${baseClass.simpleName}');

              break;
            }
          }
        }
      }
    }

    return classes;
  }

  /// Searches the [decoders] for an implementation of [decoderMirror] that
  /// converts the [model] class.
  static ClassMirror _findDecoder(ClassMirror model,
                                  ClassMirror decoderMirror,
                                  List<ClassMirror> decoders) {
    var modelDecoder;

    // Find the decoder for the type
    for (var decoder in decoders) {
      var modelMirror = decoder.superinterfaces.firstWhere(
          (interface) => interface.isSubclassOf(decoderMirror)
      ).typeArguments[0] as ClassMirror;

      if (modelMirror.isSubclassOf(model)) {
        modelDecoder = decoder;

        break;
      }
    }

    return modelDecoder;
  }

  /// Creates a new [ModelDecoder] by instantiating a new object through the
  /// class [mirror].
  static ModelDecoder _createModelDecoder(ClassMirror mirror,
                                         {Map<Symbol, dynamic> namedArguments}) {
    namedArguments ?? <Symbol, dynamic>{};

    return mirror.newInstance(_defaultConstructor, [], namedArguments)
        .reflectee as ModelDecoder;
  }

  /// Creates a new [SourceBuilder] by instantiating a new object through the
  /// class [mirror] and the [config].
  static SourceBuilder _createSourceBuilder(ClassMirror mirror,
                                            BuilderConfig config) =>
      mirror.newInstance(_defaultConstructor, [config])
          .reflectee as SourceBuilder;

  /// Creates a function which uses the [builderMirror] to instantiate a
  /// [SourceBuilder].
  ///
  /// A generic instance of [ModelDecoder] is created by using the
  /// [targetMirror] and [targetMirror].
  static BuilderCreator _defaultBuilderCreator(ClassMirror builderMirror,
                                               ClassMirror configMirror,
                                               ClassMirror targetMirror) {
    var decoder = _createModelDecoder(
        configMirror,
        namedArguments: <Symbol, dynamic>{
          #targetConfigDecoder: _createModelDecoder(targetMirror)
        }
    );

    return (input) {
      var config = decoder.convert(input) as BuilderConfig;

      return _createSourceBuilder(builderMirror, config);
    };
  }
}
