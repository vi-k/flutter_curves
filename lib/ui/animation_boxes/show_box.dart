import 'package:flutter/material.dart';

import 'animation_box.dart';

class ShowBox extends AnimationBox {
  final bool showError;
  final Color errorColor;

  const ShowBox({
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
      ..translate(0, -1)
      ..scale(1, value)
      ..drawRect(
        const Rect.fromLTRB(-1, 0, 1, 2),
        paint,
      );
  }
}
