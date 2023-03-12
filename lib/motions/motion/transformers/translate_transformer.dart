import 'package:flutter/painting.dart';

import '../motion_state.dart';
import 'motion_transformer.dart';

class TranslateTransformer extends MotionTransformerDouble {
  const TranslateTransformer({
    this.axis,
    double? begin,
    double? end,
  }) : super(
          begin: begin ?? 0,
          end: end ?? 1,
        );

  final Axis? axis;

  @override
  void transform(MotionState state, double transformedValue) {
    switch (axis) {
      case Axis.horizontal:
        state.canvas.translate(transformedValue, 0);
        break;
      case Axis.vertical:
        state.canvas.translate(0, transformedValue);
        break;
      case null:
        state.canvas.translate(transformedValue, transformedValue);
    }
  }
}

class TranslateXTransformer extends TranslateTransformer {
  const TranslateXTransformer({
    super.begin,
    super.end,
  }) : super(axis: Axis.horizontal);
}

class TranslateYTransformer extends TranslateTransformer {
  const TranslateYTransformer({
    super.begin,
    super.end,
  }) : super(axis: Axis.vertical);
}
