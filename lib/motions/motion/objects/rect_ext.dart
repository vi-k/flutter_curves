import 'dart:ui';

import 'package:flutter/painting.dart';

enum RectAlignment {
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  center,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

class RectExt extends Rect {
  const RectExt.full() : super.fromLTRB(-1, -1, 1, 1);

  const RectExt.topLeft({
    double width = 1,
    double height = 1,
  }) : super.fromLTWH(
          -1,
          -1,
          width,
          height,
        );

  const RectExt.topCenter({
    double width = 1,
    double height = 1,
  }) : super.fromLTWH(
          -width / 2,
          -1,
          width,
          height,
        );

  const RectExt.topRight({
    double width = 1,
    double height = 1,
  }) : super.fromLTWH(
          1 - width,
          -1,
          width,
          height,
        );

  const RectExt.centerLeft({
    double width = 1,
    double height = 1,
  }) : super.fromLTWH(
          -1,
          -height / 2,
          width,
          height,
        );

  const RectExt.center({
    double width = 1,
    double height = 1,
  }) : super.fromLTWH(
          -width / 2,
          -height / 2,
          width,
          height,
        );

  const RectExt.centerRight({
    double width = 1,
    double height = 1,
  }) : super.fromLTWH(
          1 - width,
          -height / 2,
          width,
          height,
        );

  const RectExt.bottomLeft({
    double width = 1,
    double height = 1,
  }) : super.fromLTWH(
          -1,
          1 - height,
          width,
          height,
        );

  const RectExt.bottomCenter({
    double width = 1,
    double height = 1,
  }) : super.fromLTWH(
          -width / 2,
          1 - height,
          width,
          height,
        );

  const RectExt.bottomRight({
    double width = 1,
    double height = 1,
  }) : super.fromLTWH(
          1 - width,
          1 - height,
          width,
          height,
        );

  const RectExt.left({double width = 1})
      : super.fromLTWH(
          -1,
          -1,
          width,
          2,
        );

  const RectExt.right({double width = 1})
      : super.fromLTWH(
          1 - width,
          -1,
          width,
          2,
        );

  const RectExt.top({double height = 1})
      : super.fromLTWH(
          -1,
          -1,
          2,
          height,
        );

  const RectExt.bottom({double height = 1})
      : super.fromLTWH(
          -1,
          1 - height,
          2,
          height,
        );
}
