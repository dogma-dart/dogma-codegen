// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_data.test.libs.model_explicit;

import 'package:dogma_data/serialize.dart';

class Explicit {
  @Serialize.field('num')
  num n;
  @Serialize.field('int')
  int i;
  @Serialize.field('double')
  double d;
  @Serialize.field('bool')
  bool b;
  @Serialize.field('string')
  String s;
  @Serialize.field('encode', decode: false)
  String encodeOnly;
  @Serialize.field('numlist')
  List<num> numList = [];
}
