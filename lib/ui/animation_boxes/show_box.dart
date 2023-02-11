import 'package:flutter/material.dart';

import 'animation_box.dart';

class ShowBox extends AnimationBox {
  final Color failColor;

  const ShowBox({
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
      ..translate(0, -1)
      ..scale(1, value)
      ..drawRect(
        const Rect.fromLTRB(-1, 0, 1, 2),
        paint,
      );
  }
}
