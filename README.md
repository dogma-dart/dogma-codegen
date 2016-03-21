# Dogma Codegen

> Code generation for the Dogma libraries

[![Build Status](http://beta.drone.io/api/badges/dogma-dart/dogma-codegen/status.svg)](http://beta.drone.io/dogma-dart/dogma-codegen)
[![Coverage Status](https://aircover.co/badges/dogma-dart/dogma-codegen/coverage.svg)](https://aircover.co/dogma-dart/dogma-codegen)
[![Pub Status](https://img.shields.io/pub/v/dogma_codegen.svg)](https://pub.dartlang.org/packages/dogma_codegen)
[![Stories in Ready](https://badge.waffle.io/dogma-dart/dogma-codegen.svg?label=ready&title=Ready)](http://waffle.io/dogma-dart/dogma-codegen)

[![Join the chat at https://gitter.im/dogma-dart/dogma-dart.github.io](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/dogma-dart/dogma-dart.github.io?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

![Release Status](https://img.shields.io/badge/status-alpha-red.svg?style=flat)

The Dogma Codegen library provides mechanisms to generate source code that interfaces with the Dogma libraries for 
creating data layers. Using the library is not mandatory, but its usage is recommended as it eliminates the boilerplate
code that needs to be written using the libraries.

Dogma Codegen can be used directly to generate source code but it is also leveraged to parse different file formats
describing models and full RESTful APIs. Before using Dogma Codegen directly consider using one of those libraries
instead as even more code can be automatically generated.

| Library | Models | Unmodifiable Views | [Convert](https://github.com/dogma-dart/dogma-convert) | [Mapper](https://github.com/dogma-dart/dogma-mapper) | [Fluent Queries](https://github.com/dogma-dart/dogma-mapper) |
|---|---|---|---|---|---|
| Codegen | :x: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :x: |
| [JSON Schema](https://github.com/dogma-dart/dogma-json-schema) | :heavy_check_mark: | :heavy_check_mark:  | :heavy_check_mark: | :heavy_check_mark: | :x: |
| [Swagger](https://github.com/dogma-dart/dogma-swagger) | :heavy_check_mark: | :heavy_check_mark:  | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |

## Getting Started

Dogma Codegen should be installed as a developer dependency. Add the following to the project's pubspec.yaml.

```yaml
dev_dependencies:
  dogma_codegen: ^0.0.1
```

It can also be installed using [den](https://pub.dartlang.org/packages/den) by using the following command 
`den install dogma_codegen --dev`.

### Package Conventions

Dogma Codegen is opinionated on the layout of the package. The following showcases the default structure.

```
+ lib
  + src
    + models
      foo.dart
      bar.dart
    + convert
      foo_convert.dart
      bar_convert.dart
  models.dart
  convert.dart
```

### Building the Library

Dogma Codegen uses a `build.dart` file at the root of the package to generate source code. For packages following the
above conventions a working `build.dart` looks like.

```dart
import 'dart:async';
import 'package:dogma_codegen/build.dart';

Future<Null> main(List<String> args) async {
  await build(args);
}
```

If the layout of the package is different then view the documentation on the `build` method and modify the values
accordingly. It is however highly recommended to stick with the prescribed layout.

#### Full Rebuilds

The `build.dart` file can be invoked directly which will cause a full rebuild of the library.

#### Incremental Builds

Dogma Codegen supports incremental builds through the [build_system](https://pub.dartlang.org/packages/build_system) 
library. Any change to the model files will be result in a rebuild when using build_system. See its documentation for
the most up to date information on using it. Dogma Codegen will continue to follow the conventions of that library to
ensure the built files are up to date with the model definitions.

## Example Projects

Working examples of various third-party APIs are available collected at the 
[Dogma Dart APIs Organization](https://github.com/dogma-dart-apis). These can be referenced for getting started with
the Dogma libraries.

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/dogma-dart/dogma-codegen/issues
