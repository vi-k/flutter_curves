import 'dart:math' as math;

import 'package:flutter/material.dart';

class CurvePainter extends CustomPainter {
  final double mx;
  final double my;
  final Animation<double> animation;
  final Curve curve;
  final Curve _reversed;
  final Paint _curvePaint;
  final Paint _valuePaint;
  final Paint _axisPaint;
  final Paint _gridPrimaryPaint;
  final Paint _gridSecondaryPaint;
  final Paint _cubicMarkerPaint;
  final Paint _cubicLinePaint;

  CurvePainter({
    required this.animation,
    required this.curve,
    required this.mx,
    required this.my,
    bool flipped = false,
    required Color curveColor,
    required Color axisColor,
    required Color gridPrimaryColor,
    required Color gridSecondaryColor,
    required Color cubicMarkerColor,
    required Color cubicLineColor,
    required Color valueColor,
  })  : _reversed = flipped ? curve.flipped : curve,
        _curvePaint = Paint()
          ..style = PaintingStyle.stroke
          ..color = curveColor,
        _valuePaint = Paint()
          ..style = PaintingStyle.fill
          ..color = valueColor,
        _axisPaint = Paint()
          ..style = PaintingStyle.stroke
          ..color = axisColor,
        _gridPrimaryPaint = Paint()
          ..style = PaintingStyle.stroke
          ..color = gridPrimaryColor,
        _gridSecondaryPaint = Paint()
          ..style = PaintingStyle.stroke
          ..color = gridSecondaryColor,
        _cubicMarkerPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = cubicMarkerColor,
        _cubicLinePaint = Paint()
          ..style = PaintingStyle.stroke
          ..color = cubicLineColor,
        super(repaint: animation);

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
    _gridPrimaryPaint.strokeWidth = px;
    _gridSecondaryPaint.strokeWidth = px;
    _curvePaint.strokeWidth = 2 * px;
    _cubicLinePaint.strokeWidth = px;

    // grid by x
    final offsetY = (my - 1) / 2;
    for (var i = 0; i <= 10; i++) {
      final paint = i % 5 == 0 ? _gridPrimaryPaint : _gridSecondaryPaint;
      final x = i / 10;
      canvas.drawLine(Offset(x, -offsetY), Offset(x, 1 + offsetY), paint);
    }

    // grid by y
    final d = ((my - 1) / 2 * 10).round();
    for (var i = -d; i <= 10 + d; i++) {
      final paint = i % 5 == 0 ? _gridPrimaryPaint : _gridSecondaryPaint;
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
      ..drawLine(startX, endX, _axisPaint)
      ..drawLine(endX - const Offset(arrowLength, arrowWidth), endX, _axisPaint)
      ..drawLine(
          endX - const Offset(arrowLength, -arrowWidth), endX, _axisPaint)
      ..drawLine(startY, endY, _axisPaint)
      ..drawLine(endY - const Offset(arrowWidth, arrowLength), endY, _axisPaint)
      ..drawLine(
          endY - const Offset(-arrowWidth, arrowLength), endY, _axisPaint);

    // curve
    final path = Path()..moveTo(0, 0);

    final step = px;
    for (var t = step; t < 1; t += step) {
      path.lineTo(t, curve.transform(t));
    }
    path.lineTo(1, 1);

    canvas.drawPath(path, _curvePaint);

    // cubic lines
    if (curve is Cubic) {
      final cubic = curve as Cubic;

      canvas
        ..drawLine(Offset.zero, Offset(cubic.a, cubic.b), _cubicLinePaint)
        ..drawLine(
            Offset(cubic.c, cubic.d), const Offset(1, 1), _cubicLinePaint)
        ..drawCircle(Offset.zero, 3 * px, _cubicMarkerPaint)
        ..drawCircle(Offset(cubic.a, cubic.b), 3 * px, _cubicMarkerPaint)
        ..drawCircle(Offset(cubic.c, cubic.d), 3 * px, _cubicMarkerPaint)
        ..drawCircle(const Offset(1, 1), 3 * px, _cubicMarkerPaint);
    }

    // value
    final value = animation.value < 0
        ? _reversed.transform(-animation.value)
        : curve.transform(animation.value);

    canvas.drawCircle(
      Offset(animation.value.abs(), value),
      5 * px,
      _valuePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CurvePainter oldDelegate) =>
      !identical(curve, oldDelegate.curve);
}
