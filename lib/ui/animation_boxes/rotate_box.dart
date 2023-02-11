import 'dart:math' as math;
import 'dart:ui';

import 'animation_box.dart';

class RotateBox extends AnimationBox {
  const RotateBox({
    super.key,
    required super.animation,
    required super.curve,
    required super.fill,
    required super.flipped,
    required super.primaryColor,
  });

  @override
  void doPaint(Canvas canvas, double value, double px, Paint paint) {
    canvas
      ..rotate(value * math.pi / 2)
      ..drawRect(
        const Rect.fromLTRB(-1, -1, 1, 1),
        paint,
      );
  }
}
