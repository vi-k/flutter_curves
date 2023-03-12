import 'dart:ui';

import '../color_type.dart';
import '../motion_state.dart';
import 'motion_object.dart';

class MotionFill extends MotionObject {
  const MotionFill({
    this.color = const DraftColor.box(),
  });

  final DraftColor color;

  @override
  void paint(MotionState state, double value) {
    final paint = Paint()
      ..color = color.colorFrom(state)
      ..style = PaintingStyle.fill;

    state.canvas.drawRRect(state.rrect, paint);

    super.paint(state, value);
  }
}
