// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_codegen.test.libs.src.convert.duration_convert;

import 'package:dogma_convert/serialize.dart';

@Serialize.using
int encodeDuration(Duration value) => value.inMilliseconds;
@Serialize.using
Duration decodeDuration(int value) => new Duration(milliseconds: value);
