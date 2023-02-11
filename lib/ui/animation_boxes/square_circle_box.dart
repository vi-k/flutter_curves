import 'package:flutter/material.dart';

import 'animation_box.dart';

class SquareCircleBox extends AnimationBox {
  final bool showError;
  final Color errorColor;

  const SquareCircleBox({
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
    final radius = value.clamp(0.0, 1.0);

    if (showError && value != radius) {
      paint.color = errorColor;
    }

    paint.strokeWidth = 2 * px;
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        -1,
        -1,
        1,
        1,
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
        bottomLeft: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      ),
      paint,
    );
  }
}
