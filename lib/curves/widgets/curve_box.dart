import 'package:flutter/material.dart';

import '../curve/curve_painter.dart';

class CurveBox extends StatelessWidget {
  const CurveBox({
    super.key,
    required this.horizontalMultiplier,
    required this.verticalMultiplier,
    required this.animation,
    required this.curve,
    required this.flipped,
  });

  final double horizontalMultiplier;
  final double verticalMultiplier;
  final Animation<double> animation;
  final Curve curve;
  final bool flipped;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: AspectRatio(
        aspectRatio: horizontalMultiplier / verticalMultiplier,
        child: CustomPaint(
          painter: CurvePainter(
            animation: animation,
            curve: curve,
            flipped: flipped,
            horizontalMultiplier: horizontalMultiplier,
            verticalMultiplier: verticalMultiplier,
            curveColor: theme.colorScheme.secondary,
            valueColor: theme.colorScheme.secondary,
            axisColor: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            gridPrimaryColor: theme.colorScheme.onSurface.withValues(
              alpha: 0.2,
            ),
            gridSecondaryColor: theme.colorScheme.onSurface.withValues(
              alpha: 0.1,
            ),
            guideMarkerColor: theme.colorScheme.tertiary,
            guideLineColor: theme.colorScheme.tertiary,
          ),
        ),
      ),
    );
  }
}
