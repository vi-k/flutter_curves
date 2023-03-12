import 'package:flutter/material.dart';

import '../curve/curve_painter.dart';

class CurveBox extends StatelessWidget {
  const CurveBox({
    super.key,
    required this.horisontalMultiplier,
    required this.verticalMultiplier,
    required this.animation,
    required this.curve,
    required this.flipped,
  });

  final double horisontalMultiplier;
  final double verticalMultiplier;
  final Animation<double> animation;
  final Curve curve;
  final bool flipped;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: AspectRatio(
        aspectRatio: horisontalMultiplier / verticalMultiplier,
        child: CustomPaint(
          painter: CurvePainter(
            animation: animation,
            curve: curve,
            flipped: flipped,
            horisontalMultiplier: horisontalMultiplier,
            verticalMultiplier: verticalMultiplier,
            curveColor: theme.colorScheme.secondary,
            valueColor: theme.colorScheme.secondary,
            axisColor: theme.colorScheme.onBackground.withOpacity(0.7),
            gridPrimaryColor: theme.colorScheme.onBackground.withOpacity(0.2),
            gridSecondaryColor: theme.colorScheme.onBackground.withOpacity(0.1),
            guideMarkerColor: theme.colorScheme.tertiary,
            guideLineColor: theme.colorScheme.tertiary,
          ),
        ),
      ),
    );
  }
}
