import 'dart:ui';

import '../color_type.dart';
import '../motion_state.dart';
import 'motion_object.dart';

class MotionText extends MotionObject {
  const MotionText(
    this.text, {
    this.fontFamily,
    this.fontSize = 0.8,
    this.color = const DraftColor.textOnBox(),
  });

  final String text;
  final String? fontFamily;
  final double fontSize;
  final DraftColor color;

  @override
  void paint(MotionState state, double value) {
    // the location of the text is rounded to integer
    const k = 1000.0;
    state.canvas.scale(1 / k);

    final p = ParagraphBuilder(
      ParagraphStyle(
        textAlign: TextAlign.center,
        fontSize: fontSize * k,
        textHeightBehavior: const TextHeightBehavior(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: false,
        ),
      ),
    )
      ..pushStyle(
        TextStyle(
          color: color.colorFrom(state),
          fontFamily: fontFamily,
          height: 1.15,
        ),
      )
      ..addText(text);

    final paragraph = p.build()
      ..layout(ParagraphConstraints(width: state.rrect.width * k));
    final height = paragraph.height;

    state.canvas.drawParagraph(
      paragraph,
      Offset(
        state.rrect.left * k,
        ((state.rrect.top + state.rrect.bottom) * k - height) / 2,
      ),
    );

    super.paint(state, value);
  }
}
