// Copyright (c) 2016, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// An annotation to link a builder to a given name.
///
/// Builders that use the [RegisterBuilder] annotation can have their
/// configuration and instances automatically created through reflection.
///
/// The other requirement is for the constructor to have the following
/// signature.
// \TODO Add information on expected signature
class RegisterBuilder {
  /// The associated name for the builder.
  ///
  /// This name is used to link a builder to a configuration. It is also used
  /// to specify the default values for where to generate files to. As such it
  /// should follow snake case naming.
  final String name;

  /// Creates an instance of [RegisterBuilder] using the given [name].
  const RegisterBuilder(this.name);
}
