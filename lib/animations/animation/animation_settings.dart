import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'animation_state.dart';
import 'transformers/transformer.dart';
import 'what.dart';

@immutable
class AnimationSettings {
  final List<Transformer> transformers;
  final Rect rect;
  final What what;
  final bool clip;

  const AnimationSettings({
    required this.transformers,
    Rect? rect,
    required this.what,
    this.clip = true,
  }) : rect = rect ?? const Rect.fromLTRB(-1, -1, 1, 1);

  // @override
  // bool operator ==(Object other) => identical(this, other) || other is AnimationSettings && rect == other.rect && what == other.what &&;

  // @override
  // int get hashCode => Object.hash(rect, what, clip);

  void doPaint(
    AnimationState state,
    double value,
  ) {
    for (final transformer in transformers) {
      transformer
        ..prepare(state)
        ..calcValueAndExecute(state, value)
        ..finalize(state);
    }

    final paint = Paint()..color = state.finalizedBoxColor;

    if (what.fill) {
      paint.style = PaintingStyle.fill;
      state.canvas.drawRRect(state.finalizedRect, paint);
    }

    if (what.border) {
      paint
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = 2 * state.px;
      state.canvas.drawRRect(state.finalizedRect, paint);
    }

    final text = what.text;
    final icon = what.icon;
    if (text != null || icon != null) {
      const k = 1000.0;
      state.canvas.scale(1 / k);

      final p = ui.ParagraphBuilder(
        ui.ParagraphStyle(
          textAlign: TextAlign.center,
          fontSize: what.fontSize * k,
          textHeightBehavior: const TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
          ),
        ),
      )
        ..pushStyle(ui.TextStyle(
          color: what.fill
              ? state.finalizedTextOnBoxColor
              : state.finalizedTextOutBoxColor,
          fontFamily: icon?.fontFamily,
          height: 1.15,
        ))
        ..addText(text ?? String.fromCharCode(icon!.codePoint));

      final paragraph = p.build()
        ..layout(ui.ParagraphConstraints(width: state.rect.width * k));
      final height = paragraph.height;

      state.canvas.drawParagraph(
        paragraph,
        Offset(
          state.rect.left * k,
          ((state.rect.top + state.rect.bottom) * k - height) / 2,
        ),
      );
    }
  }
}
