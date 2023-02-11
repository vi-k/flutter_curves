import 'package:flutter/material.dart';

import 'animation_painter.dart';

abstract class AnimationBox extends StatelessWidget {
  final Animation<double> animation;
  final Curve curve;
  final bool flipped;
  final bool keepRatio;
  final bool fill;

  const AnimationBox({
    super.key,
    required this.animation,
    required this.curve,
    this.flipped = false,
    this.keepRatio = true,
    this.fill = true,
  });

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        child: AspectRatio(
          aspectRatio: 1.2,
          child: CustomPaint(
            painter: AnimationPainter(
              animation: animation,
              curve: curve,
              flipped: flipped,
              onPaint: doPaint,
              keepRatio: keepRatio,
              color: Theme.of(context).colorScheme.primary,
              fill: fill,
            ),
          ),
        ),
      );

  void doPaint(Canvas canvas, double value, double px, Paint paint);
}
