import 'dart:math' as math;

import 'package:flutter/material.dart';

class SimpleCurvePainter extends CustomPainter {
  final double mx;
  final double my;
  final Curve curve;
  final Paint _curvePaint;
  final Paint _axisPaint;
  final Paint _gridPaint;

  SimpleCurvePainter({
    required this.curve,
    required this.mx,
    required this.my,
    required Color curveColor,
    required Color axisColor,
    required Color gridColor,
  })  : _curvePaint = Paint()
          ..style = PaintingStyle.stroke
          ..color = curveColor,
        _axisPaint = Paint()
          ..style = PaintingStyle.stroke
          ..color = axisColor,
        _gridPaint = Paint()
          ..style = PaintingStyle.stroke
          ..color = gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    final k = math.min(size.width / mx, size.height / my);
    final newSize = Size(size.width / k, size.height / k);
    final px = 1 / k;

    canvas
      ..scale(k, -k)
      ..translate(0, -newSize.height)
      ..translate((newSize.width - 1) / 2, (newSize.height - 1) / 2);

    _axisPaint.strokeWidth = px;
    _gridPaint.strokeWidth = px;
    _curvePaint.strokeWidth = 2 * px;

    // grid by x
    for (var i = 5; i <= 10; i += 5) {
      final x = i / 10;
      canvas.drawLine(Offset(x, 0), Offset(x, 1), _gridPaint);
    }

    // grid by y
    for (var i = 0; i <= 10; i += 5) {
      final x = i / 10;
      canvas.drawLine(Offset(0, x), Offset(1, x), _gridPaint);
    }

    // axises
    canvas
      ..drawLine(Offset.zero, const Offset(1, 0), _axisPaint)
      ..drawLine(Offset.zero, const Offset(0, 1), _axisPaint);

    // curve
    final path = Path()..moveTo(0, 0);

    final step = px;
    for (var t = step; t < 1; t += step) {
      path.lineTo(t, curve.transform(t));
    }
    path.lineTo(1, 1);

    canvas.drawPath(path, _curvePaint);
  }

  @override
  bool shouldRepaint(covariant SimpleCurvePainter oldDelegate) =>
      !identical(curve, oldDelegate.curve);
}
