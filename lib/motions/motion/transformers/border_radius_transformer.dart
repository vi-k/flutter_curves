import 'package:flutter/painting.dart';

import '../motion_state.dart';
import 'motion_transformer.dart';

class BorderRadiusTransformer extends MotionTransformer<BorderRadius> {
  const BorderRadiusTransformer({
    this.axis,
    BorderRadius? begin,
    BorderRadius? end,
  }) : super(
          begin: begin ?? BorderRadius.zero,
          end: end ?? const BorderRadius.all(Radius.circular(1)),
        );

  final Axis? axis;

  @override
  BorderRadius transformedValue(MotionState state, double value) =>
      BorderRadius.lerp(begin, end, value)!;

  @override
  void transform(MotionState state, BorderRadius transformedValue) {
    state.borderRadius = transformedValue;
  }
}
