import 'package:flutter/painting.dart';

import '../motion_state.dart';
import 'motion_transformer.dart';

class SkewTransformer extends MotionTransformerDouble with HasAlignment {
  const SkewTransformer({
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
  final Axis? axis;

  @override
  void transform(MotionState state, double transformedValue) {
    switch (axis) {
      case Axis.horizontal:
        state.canvas.skew(transformedValue, 0);
        break;
      case Axis.vertical:
        state.canvas.skew(0, transformedValue);
        break;
      case null:
        state.canvas.skew(transformedValue, transformedValue);
    }
  }
}

class SkewXTransformer extends SkewTransformer {
  const SkewXTransformer({
    super.begin,
    super.end,
    super.alignment,
  }) : super(axis: Axis.horizontal);
}

class SkewYTransformer extends SkewTransformer {
  const SkewYTransformer({
    super.begin,
    super.end,
    super.alignment,
  }) : super(axis: Axis.vertical);
}
