import 'package:flutter/painting.dart';

import '../animation_state.dart';
import 'transformer.dart';

class BoxRadiusTransformer extends Transformer<BorderRadius> {
  final Axis? axis;

  const BoxRadiusTransformer({
    this.axis,
    BorderRadius? begin,
    BorderRadius? end,
  }) : super(
          begin: begin ?? const BorderRadius.all(Radius.zero),
          end: end ?? const BorderRadius.all(Radius.circular(1)),
        );

  @override
  BorderRadius transform(AnimationState state, double value) =>
      BorderRadius.lerp(begin, end, value)!;

  @override
  void execute(AnimationState state, BorderRadius transformedValue) {
    state.finalizedRect = transformedValue.toRRect(state.rect);
  }
}
