import 'package:flutter/material.dart';

import '../animation/animation_painter.dart';
import '../animation/animation_settings.dart';
import '../animation/animation_state.dart';

class AnimationBox extends StatelessWidget {
  final AnimationSettings settings;
  final Animation<double> animation;
  final double borderRadius;
  final Curve curve;
  final bool flipped;
  final Color boxColor;
  final Color alternateColor;
  final Color textOnBoxColor;
  final Color textOutBoxColor;
  final void Function()? onTap;

  const AnimationBox({
    super.key,
    required this.settings,
    required this.animation,
    required this.borderRadius,
    required this.curve,
    required this.flipped,
    required this.boxColor,
    required this.alternateColor,
    required this.textOnBoxColor,
    required this.textOutBoxColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final box = AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: AnimationPainter(
          animation: animation,
          curve: curve,
          flipped: flipped,
          onPaint: (canvas, t, px) {
            final state = AnimationState(
              canvas: canvas,
              px: px,
              rect: settings.rect,
              boxColor: boxColor,
              alternateColor: alternateColor,
              textOnBoxColor: textOnBoxColor,
              textOutBoxColor: textOutBoxColor,
            );

            settings.doPaint(state, t);
          },
        ),
      ),
    );

    return RepaintBoundary(
      child: Material(
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.inversePrimary,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            ),
          ),
          child: !settings.clip
              ? box
              : InkWell(
                  onTap: onTap,
                  child: box,
                ),
        ),
      ),
    );
  }
}
