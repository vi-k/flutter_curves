import 'package:flutter/material.dart';

import '../curve/simple_curve_painter.dart';

class SimpleCurveBox extends StatelessWidget {
  final Curve curve;
  final Color curveColor;

  const SimpleCurveBox({
    required this.curve,
    required this.curveColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: CustomPaint(
          painter: SimpleCurvePainter(
            curve: curve,
            mx: 1,
            my: 1,
            curveColor: curveColor,
            axisColor: theme.colorScheme.onBackground.withOpacity(0.5),
            gridColor: theme.colorScheme.onBackground.withOpacity(0.2),
          ),
        ),
      ),
    );
  }
}
