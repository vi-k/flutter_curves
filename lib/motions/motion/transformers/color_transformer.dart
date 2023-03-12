import 'dart:ui';

import '../color_type.dart';
import '../motion_state.dart';
import 'motion_transformer.dart';

class ColorTransformer extends MotionTransformer<DraftColor> {
  const ColorTransformer({
    required this.color,
    DraftColor? begin,
    DraftColor? end,
  }) : super(
          begin: begin ?? const DraftColor.box(),
          end: end ?? const DraftColor.alternate(),
        );

  final ObjectColor color;

  @override
  DraftColor transformedValue(MotionState state, double value) {
    final beginColor = begin.colorFrom(state);
    final endColor = end.colorFrom(state);

    return DraftColor(Color.lerp(beginColor, endColor, value));
  }

  @override
  void transform(MotionState state, DraftColor transformedValue) {
    color.setColorTo(state, transformedValue.colorFrom(state));
  }
}
