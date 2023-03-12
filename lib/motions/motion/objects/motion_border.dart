import 'dart:ui';

import '../color_type.dart';
import '../motion_state.dart';
import 'motion_object.dart';

class MotionBorder extends MotionObject {
  const MotionBorder({
    this.color = const DraftColor.box(),
    this.width = 2,
  });

  final DraftColor color;
  final double width;

  @override
  void paint(MotionState state, double value) {
    final paint = Paint()
      ..color = color.colorFrom(state)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = width * state.px;

    state.canvas.drawRRect(state.rrect, paint);

    super.paint(state, value);
  }
}
