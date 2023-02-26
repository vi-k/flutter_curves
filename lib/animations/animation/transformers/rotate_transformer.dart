import 'dart:math' as math;

import 'package:flutter/painting.dart';

import '../animation_state.dart';
import 'transformer.dart';

class RotateTransformer extends DoubleTypeTransformer with HasAlignment {
  @override
  final Alignment alignment;

  const RotateTransformer({
    Alignment? alignment,
    double? begin,
    double? end,
  })  : alignment = alignment ?? Alignment.center,
        super(
          begin: begin ?? 0,
          end: end ?? math.pi / 2,
        );

  @override
  void execute(AnimationState state, double transformedValue) =>
      state.canvas.rotate(transformedValue);
}
