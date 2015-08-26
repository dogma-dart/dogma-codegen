// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

library dogma_data.test.libs.enum_explicit;

import 'package:dogma_data/serialize.dart';

@Serialize.values(const {
  0x0000ff: ColorExplicit.blue,
  0xff0000: ColorExplicit.red,
  0x00ff00: ColorExplicit.green
})
enum ColorExplicit {
  red,
  green,
  blue
}
