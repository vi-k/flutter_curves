import 'package:flutter/material.dart';

import 'animation_box.dart';

class ColorBox extends AnimationBox {
  final Color secondaryColor;
  final bool showError;
  final Color errorColor;

  const ColorBox({
    super.key,
    required super.animation,
    required super.curve,
    required super.fill,
    required super.flipped,
    required super.primaryColor,
    required this.showError,
    required this.secondaryColor,
    required this.errorColor,
  });

  @override
  void doPaint(Canvas canvas, double value, double px, Paint paint) {
    final v = value.clamp(0.0, 1.0);
    paint.color = showError && value != v
        ? errorColor
        : Color.lerp(paint.color, secondaryColor, v)!;

    canvas.drawRect(
      const Rect.fromLTRB(-1, -1, 1, 1),
      paint,
    );
  }
}
