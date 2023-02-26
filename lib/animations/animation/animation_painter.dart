import 'dart:math' as math;

import 'package:flutter/animation.dart';
import 'package:flutter/rendering.dart';

typedef Painter = void Function(
  Canvas canvas,
  double value,
  double px,
);

class AnimationPainter extends CustomPainter {
  final Animation<double> animation;
  final Curve curve;
  final Curve _reversed;
  final bool fill;
  final Painter onPaint;
  final bool keepRatio;

  AnimationPainter({
    required this.animation,
    required this.curve,
    required this.onPaint,
    this.keepRatio = true,
    this.fill = false,
    bool flipped = false,
  })  : _reversed = flipped ? curve.flipped : curve,
        super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    var kx = size.width / 2 * 0.8;
    var ky = size.height / 2 * 0.8;
    if (keepRatio) {
      kx = ky = math.min(kx, ky);
    }
    canvas
      ..translate(size.width / 2, size.height / 2)
      ..scale(kx, ky);

    final px = 1 / math.min(kx, ky);

    final value = animation.value < 0
        ? _reversed.transform(-animation.value)
        : curve.transform(animation.value);

    onPaint(canvas, value, px);
  }

  @override
  bool shouldRepaint(covariant AnimationPainter oldDelegate) => true;
}
