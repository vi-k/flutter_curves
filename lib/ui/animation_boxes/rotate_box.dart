import 'dart:math' as math;
import 'dart:ui';

import 'animation_box.dart';

class RotateBox extends AnimationBox {
  const RotateBox({
    super.key,
    required super.animation,
    required super.curve,
    required super.flipped,
    super.fill = true,
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
