import 'package:flutter/material.dart';

import 'animation_box.dart';

class ScaleBox extends AnimationBox {
  final bool showError;
  final Color errorColor;

  const ScaleBox({
    super.key,
    required super.animation,
    required super.curve,
    required super.fill,
    required super.flipped,
    required super.primaryColor,
    required this.showError,
    required this.errorColor,
  });

  @override
  void doPaint(Canvas canvas, double value, double px, Paint paint) {
    if (showError && value < 0) {
      paint.color = errorColor;
    }

    canvas
      ..scale(value)
      ..drawRect(
        const Rect.fromLTRB(-1, -1, 1, 1),
        paint,
      );
  }
}
