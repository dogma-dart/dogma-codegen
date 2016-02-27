// Copyright (c) 2015-2016 the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

/// Definition of a function that generates annotations.
///
/// The generator should test the type of [value] to determine if the annotation
/// declaration should be written to the [buffer].
typedef void AnnotationGenerator(dynamic value, StringBuffer buffer);
