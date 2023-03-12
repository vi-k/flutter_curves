import 'dart:math' as math;

import 'package:flutter/painting.dart';

import '../motion_state.dart';
import 'motion_transformer.dart';

class RotateTransformer extends MotionTransformerDouble with HasAlignment {
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
  final Alignment alignment;

  @override
  void transform(MotionState state, double transformedValue) =>
      state.canvas.rotate(transformedValue);
}
