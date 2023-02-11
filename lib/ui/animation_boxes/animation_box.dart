import 'package:flutter/material.dart';

import '../constants.dart';
import 'animation_painter.dart';

abstract class AnimationBox extends StatelessWidget {
  final Animation<double> animation;
  final Curve curve;
  final bool fill;
  final bool flipped;
  final Color primaryColor;
  final bool keepRatio;

  const AnimationBox({
    super.key,
    required this.animation,
    required this.curve,
    required this.fill,
    required this.flipped,
    required this.primaryColor,
    this.keepRatio = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.inversePrimary,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(Const.defaultRadius),
          ),
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: CustomPaint(
            painter: AnimationPainter(
              animation: animation,
              curve: curve,
              flipped: flipped,
              onPaint: doPaint,
              keepRatio: keepRatio,
              color: primaryColor,
              fill: fill,
            ),
          ),
        ),
      ),
    );
  }

  void doPaint(Canvas canvas, double value, double px, Paint paint);
}
