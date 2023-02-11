import 'package:flutter/material.dart';

import 'animation_box.dart';

class ScaleBox extends AnimationBox {
  final Color failColor;

  const ScaleBox({
    super.key,
    required super.animation,
    required super.curve,
    required super.flipped,
    super.fill = true,
    this.failColor = Colors.yellow,
  });

  @override
  void doPaint(Canvas canvas, double value, double px, Paint paint) {
    if (value < 0) paint.color = failColor;
    canvas
      ..scale(value)
      ..drawRect(
        const Rect.fromLTRB(-1, -1, 1, 1),
        paint,
      );
  }
}
