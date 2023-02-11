import 'dart:math' as math;

import 'package:flutter/material.dart';

class CurvePainter extends CustomPainter {
  final double mx;
  final double my;
  final Animation<double> animation;
  final Curve curve;
  final Curve _reversed;

  final axisPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.black54;

  final grid1Paint = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.grey.shade300;

  final grid2Paint = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.grey.shade200;

  final curvePaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.red;

  final cubicMarkerPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.blue.withOpacity(0.5);

  final cubicLinePaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.blue.withOpacity(0.5);

  final valuePaint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.red;

  CurvePainter({
    required this.animation,
    required this.curve,
    required this.mx,
    required this.my,
    bool flipped = false,
  }) : _reversed = flipped ? curve.flipped : curve;

  @override
  void paint(Canvas canvas, Size size) {
    final k = math.min(size.width / mx, size.height / my);
    final newSize = Size(size.width / k, size.height / k);
    final px = 1 / k;

    canvas
      ..scale(k, -k)
      ..translate(0, -newSize.height)
      ..translate((newSize.width - 1) / 2, (newSize.height - 1) / 2);

    axisPaint.strokeWidth = px;
    grid1Paint.strokeWidth = px;
    grid2Paint.strokeWidth = px;
    curvePaint.strokeWidth = 2 * px;
    cubicLinePaint.strokeWidth = px;

    // grid by x
    for (var i = 0; i <= 10; i++) {
      final paint = i % 5 == 0 ? grid1Paint : grid2Paint;
      final x = i / 10;
      canvas.drawLine(Offset(x, -0.3), Offset(x, 1.3), paint);
    }

    // grid by y
    for (var i = -3; i <= 13; i++) {
      final paint = i % 5 == 0 ? grid1Paint : grid2Paint;
      final x = i / 10;
      canvas.drawLine(Offset(0, x), Offset(1, x), paint);
    }

    // axises
    const startX = Offset.zero;
    const endX = Offset(1, 0);
    const startY = Offset.zero;
    const endY = Offset(0, 1);
    const arrowLength = 0.06;
    const arrowWidth = 0.01;
    canvas
      ..drawLine(startX, endX, axisPaint)
      ..drawLine(endX - const Offset(arrowLength, arrowWidth), endX, axisPaint)
      ..drawLine(endX - const Offset(arrowLength, -arrowWidth), endX, axisPaint)
      ..drawLine(startY, endY, axisPaint)
      ..drawLine(endY - const Offset(arrowWidth, arrowLength), endY, axisPaint)
      ..drawLine(
          endY - const Offset(-arrowWidth, arrowLength), endY, axisPaint);

    // кривая
    final path = Path()..moveTo(0, 0);

    final step = px;
    for (var t = step; t < 1; t += step) {
      path.lineTo(t, curve.transform(t));
    }
    path.lineTo(1, 1);

    canvas.drawPath(path, curvePaint);

    if (curve is Cubic) {
      final cubic = curve as Cubic;

      canvas
        ..drawLine(Offset.zero, Offset(cubic.a, cubic.b), cubicLinePaint)
        ..drawLine(Offset(cubic.c, cubic.d), const Offset(1, 1), cubicLinePaint)
        ..drawCircle(Offset.zero, 3 * px, cubicMarkerPaint)
        ..drawCircle(Offset(cubic.a, cubic.b), 3 * px, cubicMarkerPaint)
        ..drawCircle(Offset(cubic.c, cubic.d), 3 * px, cubicMarkerPaint)
        ..drawCircle(const Offset(1, 1), 3 * px, cubicMarkerPaint);
    }

    final value = animation.value < 0
        ? _reversed.transform(-animation.value)
        : curve.transform(animation.value);

    canvas.drawCircle(Offset(animation.value.abs(), value), 5 * px, valuePaint);
  }

  @override
  bool shouldRepaint(covariant CurvePainter oldDelegate) =>
      !identical(curve, oldDelegate.curve);
}
