import 'package:flutter/painting.dart';

import '../motion_state.dart';
import 'motion_transformer.dart';

class ScaleTransformer extends MotionTransformerDouble
    with HasAlignment, HasAxis {
  const ScaleTransformer({
    Alignment? alignment,
    this.axis,
    double? begin,
    double? end,
  })  : alignment = alignment ?? Alignment.center,
        super(
          begin: begin ?? 0,
          end: end ?? 1,
        );

  @override
  final Alignment alignment;
  @override
  final Axis? axis;

  @override
  void transform(MotionState state, double transformedValue) {
    switch (axis) {
      case Axis.horizontal:
        state.canvas.scale(transformedValue, 1);
        break;
      case Axis.vertical:
        state.canvas.scale(1, transformedValue);
        break;
      case null:
        state.canvas.scale(transformedValue, transformedValue);
    }
  }
}

class ScaleXTransformer extends ScaleTransformer {
  const ScaleXTransformer({
    super.alignment,
    super.begin,
    super.end,
  }) : super(axis: Axis.horizontal);
}

class ScaleYTransformer extends ScaleTransformer {
  const ScaleYTransformer({
    super.alignment,
    super.begin,
    super.end,
  }) : super(axis: Axis.vertical);
}
