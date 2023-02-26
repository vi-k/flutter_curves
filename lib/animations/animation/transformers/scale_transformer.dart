import 'package:flutter/painting.dart';

import '../animation_state.dart';
import 'transformer.dart';

class ScaleTransformer extends DoubleTypeTransformer
    with HasAlignment, HasAxis, HasError {
  @override
  final Alignment alignment;
  @override
  final Axis? axis;
  @override
  final bool showError;

  const ScaleTransformer({
    Alignment? alignment,
    this.axis,
    bool? showError,
    double? begin,
    double? end,
  })  : alignment = alignment ?? Alignment.center,
        showError = showError ?? true,
        super(
          begin: begin ?? 0,
          end: end ?? 1,
        );

  @override
  void execute(AnimationState state, double transformedValue) {
    switch (axis) {
      case Axis.horizontal:
        state.canvas.scale(transformedValue, 1);
        break;
      case Axis.vertical:
        state.canvas.scale(1, transformedValue);
        break;
      default:
        state.canvas.scale(transformedValue, transformedValue);
    }
  }

  @override
  bool hasError(double value) => showError && value < 0;
}

class ScaleXTransformer extends ScaleTransformer {
  const ScaleXTransformer({
    super.alignment,
    super.showError,
    super.begin,
    super.end,
  }) : super(axis: Axis.horizontal);
}

class ScaleYTransformer extends ScaleTransformer {
  const ScaleYTransformer({
    super.alignment,
    super.showError,
    super.begin,
    super.end,
  }) : super(axis: Axis.vertical);
}
