import 'package:flutter/painting.dart';

import '../animation_state.dart';
import 'transformer.dart';

class TranslateTransformer extends DoubleTypeTransformer {
  final Axis? axis;

  const TranslateTransformer({
    this.axis,
    double? begin,
    double? end,
  }) : super(
          begin: begin ?? 0,
          end: end ?? 1,
        );

  @override
  void execute(AnimationState state, double transformedValue) {
    switch (axis) {
      case Axis.horizontal:
        state.canvas.translate(transformedValue, 0);
        break;
      case Axis.vertical:
        state.canvas.translate(0, transformedValue);
        break;
      default:
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
