import 'dart:ui';

import 'animation_box.dart';

class OpacityBox extends AnimationBox {
  const OpacityBox({
    super.key,
    required super.animation,
    required super.curve,
    required super.flipped,
    super.fill = true,
  });

  @override
  void doPaint(Canvas canvas, double value, double px, Paint paint) {
    paint.color = paint.color.withOpacity(value.clamp(0, 1));
    canvas.drawRect(
      const Rect.fromLTRB(-1, -1, 1, 1),
      paint,
    );
  }
}
