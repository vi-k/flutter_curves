import 'dart:math' as math;

import 'package:flutter/material.dart';

class CurvePainter extends CustomPainter {
  CurvePainter({
    required this.animation,
    required this.curve,
    required this.horisontalMultiplier,
    required this.verticalMultiplier,
    required Color curveColor,
    required Color axisColor,
    required Color gridPrimaryColor,
    required Color gridSecondaryColor,
    required Color guideMarkerColor,
    required Color guideLineColor,
    required Color valueColor,
    bool flipped = false,
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
          ..color = guideMarkerColor,
        _cubicLinePaint = Paint()
          ..style = PaintingStyle.stroke
          ..color = guideLineColor,
        super(repaint: animation);

  final double horisontalMultiplier;
  final double verticalMultiplier;
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

  @override
  void paint(Canvas canvas, Size size) {
    final ratio = math.min(
      size.width / horisontalMultiplier,
      size.height / verticalMultiplier,
    );
    final newSize = Size(size.width / ratio, size.height / ratio);
    final px = 1 / ratio;

    canvas
      ..scale(ratio, -ratio)
      ..translate(0, -newSize.height)
      ..translate((newSize.width - 1) / 2, (newSize.height - 1) / 2);

    _axisPaint.strokeWidth = px;
    _gridPrimaryPaint.strokeWidth = px;
    _gridSecondaryPaint.strokeWidth = px;
    _curvePaint.strokeWidth = 2 * px;
    _cubicLinePaint.strokeWidth = px;

    // grid by x
    final offsetY = (verticalMultiplier - 1) / 2;
    final dx = ((horisontalMultiplier - 1) / 2 * 10).round();
    for (var i = -dx; i <= 10 + dx; i++) {
      final paint = i % 5 == 0 ? _gridPrimaryPaint : _gridSecondaryPaint;
      final x = i / 10;
      canvas.drawLine(Offset(x, -offsetY), Offset(x, 1 + offsetY), paint);
    }

    // grid by y
    final offsetX = (horisontalMultiplier - 1) / 2;
    final dy = ((verticalMultiplier - 1) / 2 * 10).round();
    for (var i = -dy; i <= 10 + dy; i++) {
      final paint = i % 5 == 0 ? _gridPrimaryPaint : _gridSecondaryPaint;
      final y = i / 10;
      canvas.drawLine(Offset(-offsetX, y), Offset(1 + offsetX, y), paint);
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
        endX - const Offset(arrowLength, -arrowWidth),
        endX,
        _axisPaint,
      )
      ..drawLine(startY, endY, _axisPaint)
      ..drawLine(endY - const Offset(arrowWidth, arrowLength), endY, _axisPaint)
      ..drawLine(
        endY - const Offset(-arrowWidth, arrowLength),
        endY,
        _axisPaint,
      );

    // curve
    final curve = this.curve;
    final path = Path()..moveTo(0, 0);

    final step = px;
    for (var t = step; t < 1; t += step) {
      path.lineTo(t, curve.transform(t));
    }
    path.lineTo(1, 1);

    canvas.drawPath(path, _curvePaint);

    // cubic lines
    if (curve is Cubic) {
      canvas
        ..drawLine(Offset.zero, Offset(curve.a, curve.b), _cubicLinePaint)
        ..drawLine(
          const Offset(1, 1),
          Offset(curve.c, curve.d),
          _cubicLinePaint,
        )
        ..drawCircle(Offset.zero, 3 * px, _cubicMarkerPaint)
        ..drawCircle(Offset(curve.a, curve.b), 3 * px, _cubicMarkerPaint)
        ..drawCircle(Offset(curve.c, curve.d), 3 * px, _cubicMarkerPaint)
        ..drawCircle(const Offset(1, 1), 3 * px, _cubicMarkerPaint);
    } else if (curve is ThreePointCubic) {
      canvas
        ..drawLine(Offset.zero, curve.a1, _cubicLinePaint)
        ..drawLine(curve.midpoint, curve.b1, _cubicLinePaint)
        ..drawLine(curve.midpoint, curve.a2, _cubicLinePaint)
        ..drawLine(const Offset(1, 1), curve.b2, _cubicLinePaint)
        ..drawCircle(Offset.zero, 3 * px, _cubicMarkerPaint)
        ..drawCircle(curve.a1, 3 * px, _cubicMarkerPaint)
        ..drawCircle(curve.b1, 3 * px, _cubicMarkerPaint)
        ..drawCircle(curve.midpoint, 3 * px, _cubicMarkerPaint)
        ..drawCircle(curve.a2, 3 * px, _cubicMarkerPaint)
        ..drawCircle(curve.b2, 3 * px, _cubicMarkerPaint)
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
