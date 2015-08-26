// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_data.test.libs.converter_functions_implicit;

// These functions should be picked up as potential converters
int encodeDuration(Duration value) => value.inMilliseconds;
Duration decodeDuration(int value) => new Duration(milliseconds: value);

// These functions should not be picked up as potential converters
bool notPresent(String value0, String value1) => value0 == value1;
