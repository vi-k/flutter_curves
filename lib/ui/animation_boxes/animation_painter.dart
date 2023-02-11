import 'dart:math' as math;

import 'package:flutter/material.dart';

typedef Painter = void Function(
    Canvas canvas, double value, double px, Paint paint);

class AnimationPainter extends CustomPainter {
  final Animation<double> animation;
  final Curve curve;
  final Curve _reversed;
  final bool fill;
  final Painter onPaint;
  final bool keepRatio;
  final Color color;

  AnimationPainter({
    required this.animation,
    required this.curve,
    required this.onPaint,
    required this.color,
    this.keepRatio = false,
    this.fill = false,
    bool flipped = false,
  })  : _reversed = flipped ? curve.flipped : curve,
        super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    const padding = 8;
    var kx = size.width / 2 - padding;
    var ky = size.height / 2 - padding;
    if (keepRatio) {
      kx = ky = math.min(kx, ky);
    }
    canvas
      ..translate(size.width / 2, size.height / 2)
      ..scale(kx, -ky);

    final px = 1 / math.min(kx, ky);

    final value = animation.value < 0
        ? _reversed.transform(-animation.value)
        : curve.transform(animation.value);
    final paint = Paint()
      ..color = color
      ..style = fill ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 2 * px;
    onPaint(canvas, value, px, paint);
  }

  @override
  bool shouldRepaint(covariant AnimationPainter oldDelegate) => true;
}
