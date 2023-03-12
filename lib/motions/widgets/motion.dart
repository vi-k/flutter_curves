import 'package:flutter/material.dart';

import '../motion/motion_state.dart';
import '../motion/objects/motion_object.dart';
import 'motion_painter.dart';

class Motion extends StatelessWidget {
  const Motion({
    super.key,
    required this.motion,
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

  final MotionObject motion;
  final Animation<double> animation;
  final double borderRadius;
  final Curve curve;
  final bool flipped;
  final Color boxColor;
  final Color alternateColor;
  final Color textOnBoxColor;
  final Color textOutBoxColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final box = AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: MotionPainter(
          animation: animation,
          curve: curve,
          flipped: flipped,
          onPaint: (canvas, t, px) {
            final state = MotionState(
              canvas: canvas,
              px: px,
              rect: motion.rect ?? const Rect.fromLTRB(-1, -1, 1, 1),
              brightness: theme.brightness,
              boxColor: boxColor,
              alternateColor: alternateColor,
              textOnBoxColor: textOnBoxColor,
              textOutBoxColor: textOutBoxColor,
            );

            motion.paint(state, t);
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
          child: !motion.clip
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
