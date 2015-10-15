// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.test.libs.src.convert.duration_minutes_convert;

int encodeDurationInMinutes(Duration value) => value.inMinutes;
Duration decodeDurationInMinutes(int value) => new Duration(minutes: value);
