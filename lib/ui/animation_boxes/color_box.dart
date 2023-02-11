import 'package:flutter/material.dart';

import 'animation_box.dart';

class ColorBox extends AnimationBox {
  final Color? primaryColor;
  final Color secondColor;
  final Color failColor;

  const ColorBox({
    super.key,
    required super.animation,
    required super.curve,
    required super.flipped,
    this.primaryColor,
    required this.secondColor,
    super.fill = true,
    this.failColor = Colors.yellow,
  });

  @override
  void doPaint(Canvas canvas, double value, double px, Paint paint) {
    final v = value.clamp(0.0, 1.0);
    paint.color = value != v
        ? failColor
        : Color.lerp(primaryColor ?? paint.color, secondColor, v)!;

    canvas.drawRect(
      const Rect.fromLTRB(-1, -1, 1, 1),
      paint,
    );
  }
}
