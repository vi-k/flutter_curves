import 'package:flutter/painting.dart';

import '../animation_state.dart';
import 'transformer.dart';

class SkewTransformer extends DoubleTypeTransformer with HasAlignment {
  @override
  final Alignment alignment;
  final Axis? axis;

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
  void execute(AnimationState state, double transformedValue) {
    switch (axis) {
      case Axis.horizontal:
        state.canvas.skew(transformedValue, 0);
      case Axis.vertical:
        state.canvas.skew(0, transformedValue);
      default:
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
