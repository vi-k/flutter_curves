import 'dart:ui';

import '../animation_state.dart';
import 'transformer.dart';

enum _DraftColorType {
  box,
  alternate,
  textOnBox,
  textOutBox,
  notDraft,
}

enum ColorType {
  box,
  textOnBox,
  textOutBox,
}

class DraftColor {
  final _DraftColorType _draft;
  final double _draftOpacity;
  final Color? _color;

  const DraftColor._(this._draft, this._draftOpacity) : _color = null;

  const DraftColor.box([double opacity = 1])
      : this._(_DraftColorType.box, opacity);
  const DraftColor.alternate([double opacity = 1])
      : this._(_DraftColorType.alternate, opacity);
  const DraftColor.textOnBox([double opacity = 1])
      : this._(_DraftColorType.textOnBox, opacity);
  const DraftColor.textOutBox([double opacity = 1])
      : this._(_DraftColorType.textOutBox, opacity);

  const DraftColor(this._color)
      : _draft = _DraftColorType.notDraft,
        _draftOpacity = 1;

  Color get color => _color!;
}

class ColorTransformer extends Transformer<DraftColor> {
  final ColorType colorType;

  const ColorTransformer({
    required this.colorType,
    DraftColor? begin,
    DraftColor? end,
  }) : super(
          begin: begin ?? const DraftColor.box(),
          end: end ?? const DraftColor.alternate(),
        );

  static Color colorFromDraft(AnimationState state, DraftColor draft) {
    switch (draft._draft) {
      case _DraftColorType.box:
        return state.boxColor.withOpacity(draft._draftOpacity);
      case _DraftColorType.alternate:
        return state.alternateColor.withOpacity(draft._draftOpacity);
      case _DraftColorType.textOnBox:
        return state.textOnBoxColor.withOpacity(draft._draftOpacity);
      case _DraftColorType.textOutBox:
        return state.textOutBoxColor.withOpacity(draft._draftOpacity);
      case _DraftColorType.notDraft:
        return draft.color.withOpacity(draft._draftOpacity);
    }
  }

  @override
  DraftColor transform(AnimationState state, double value) {
    final beginColor = colorFromDraft(state, begin);
    final endColor = colorFromDraft(state, end);

    return DraftColor(Color.lerp(beginColor, endColor, value)!);
  }

  @override
  void execute(AnimationState state, DraftColor transformedValue) {
    switch (colorType) {
      case ColorType.box:
        state.finalizedBoxColor = transformedValue.color;
        break;
      case ColorType.textOnBox:
        state.finalizedTextOnBoxColor = transformedValue.color;
        break;
      case ColorType.textOutBox:
        state.finalizedTextOutBoxColor = transformedValue.color;
        break;
    }
  }
}
