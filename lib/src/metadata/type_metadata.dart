// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [TypeMetadata] class.
library dogma_codegen.src.metadata.type_metadata;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'metadata.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

const String _bool = 'bool';
const String _int = 'int';
const String _num = 'num';
const String _double = 'double';
const String _string = 'String';
const String _list = 'List';
const String _map = 'Map';

/// Contains metadata for a type.
///
/// Information such as interfaces, base class, and mixin is not present in the
/// metadata as Dogma data only handles Plain Old Dart Objects which do not
/// have inheritance.
class TypeMetadata extends Metadata {
  /// The type arguments.
  ///
  /// This is only present on generic types.
  final List<TypeMetadata> arguments;

  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Creates an instance of [TypeMetadata] with the given [name].
  ///
  /// If the type is generic then [arguments] should be used to fully type the
  /// metadata.
  TypeMetadata(String name, {List<TypeMetadata> arguments})
      : arguments = arguments ?? []
      , super(name);

  TypeMetadata.bool()
      : arguments = []
      , super(_bool);

  TypeMetadata.int()
      : arguments = []
      , super(_int);

  TypeMetadata.double()
      : arguments = []
      , super(_double);

  TypeMetadata.num()
      : arguments = []
      , super(_num);

  TypeMetadata.string()
      : arguments = []
      , super(_string);

  TypeMetadata.list([TypeMetadata argument])
      : arguments = (argument != null) ? [argument] : []
      , super(_list);

  factory TypeMetadata.map([TypeMetadata key, TypeMetadata value]) {
    var arguments = new List<TypeMetadata>();

    // Add type arguments only if key is not null
    if (key != null) {
      arguments.add(key);

      if (value != null) {
        arguments.add(value);
      }
    }

    return new TypeMetadata._internal(_map, arguments);
  }

  /// Creates an instance of [TypeMetadata].
  TypeMetadata._internal(String name, this.arguments)
      : super(name);

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// Whether the type is an integer.
  bool get isInt => name == _int;
  /// Whether the type is a double.
  bool get isDouble => name == _double;
  /// Whether the type is a number.
  bool get isNum => isInt || isDouble || name == _num;
  /// Whether the type is a boolean.
  bool get isBool => name == _bool;
  /// Whether the type is a string.
  bool get isString => name == _string;
  /// Whether the type is a list.
  bool get isList => name == _list;
  /// Whether the type is a map.
  bool get isMap => name == _map;

  /// Whether the type is built in.
  ///
  /// Builtin refers to the base types present in dart:core that can be
  /// (de)serialized directly in a JSON payload without conversion. This is
  /// done recursively for generic types.
  bool get isBuiltin {
    var value;

    // Check for lists and maps as the type arguments need to be checked
    if (isList || isMap) {
      value = true;

      for (var argument in arguments) {
        if (!argument.isBuiltin) {
          value = false;
          break;
        }
      }
    } else {
      value = isNum || isBool || isString;
    }

    return value;
  }

  //---------------------------------------------------------------------
  // Operators
  //---------------------------------------------------------------------

  @override
  bool operator== (Object compare) {
    if (identical(this, compare)) {
      return true;
    } else if (compare is TypeMetadata) {
      return name == compare.name;
    } else {
      return false;
    }
  }
}
