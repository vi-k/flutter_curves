import 'dart:ui';

import 'motion_state.dart';

enum DraftColorType {
  box,
  alternate,
  textOnBox,
  textOutBox,
  finished,
}

class DraftColor {
  const DraftColor(this.light, [Color? dark])
      : type = DraftColorType.finished,
        dark = dark ?? light,
        opacity = 1;

  const DraftColor._(this.type, this.opacity)
      : light = null,
        dark = null;

  DraftColor.byColorType(ObjectColor colorType, double draftOpacity)
      : this._(colorType._draftType, draftOpacity);

  const DraftColor.box([double opacity = 1])
      : this._(DraftColorType.box, opacity);
  const DraftColor.alternate([double opacity = 1])
      : this._(DraftColorType.alternate, opacity);
  const DraftColor.textOnBox([double opacity = 1])
      : this._(DraftColorType.textOnBox, opacity);
  const DraftColor.textOutBox([double opacity = 1])
      : this._(DraftColorType.textOutBox, opacity);

  final DraftColorType type;
  final double opacity;
  final Color? light;
  final Color? dark;

  Color colorFrom(MotionState state) {
    late Color color;

    switch (type) {
      case DraftColorType.box:
        color = state.boxColor;
        break;
      case DraftColorType.alternate:
        color = state.alternateColor;
        break;
      case DraftColorType.textOnBox:
        color = state.textOnBoxColor;
        break;
      case DraftColorType.textOutBox:
        color = state.textOutBoxColor;
        break;
      case DraftColorType.finished:
        color = state.brightness == Brightness.light ? light! : dark!;
        break;
    }

    return color.withOpacity(color.opacity * opacity);
  }
}

enum ObjectColor {
  box(DraftColorType.box),
  textOnBox(DraftColorType.textOnBox),
  textOutBox(DraftColorType.textOutBox);

  const ObjectColor(this._draftType);

  final DraftColorType _draftType;

  Color initialColorFrom(MotionState state) {
    switch (this) {
      case ObjectColor.box:
        return state.initialBoxColor;
      case ObjectColor.textOnBox:
        return state.initialTextOnBoxColor;
      case ObjectColor.textOutBox:
        return state.initialTextOutBoxColor;
    }
  }

  Color colorFrom(MotionState state) {
    switch (this) {
      case ObjectColor.box:
        return state.boxColor;
      case ObjectColor.textOnBox:
        return state.textOnBoxColor;
      case ObjectColor.textOutBox:
        return state.textOutBoxColor;
    }
  }

  void setColorTo(MotionState state, Color color) {
    switch (this) {
      case ObjectColor.box:
        state.boxColor = color;
        break;
      case ObjectColor.textOnBox:
        state.textOnBoxColor = color;
        break;
      case ObjectColor.textOutBox:
        state.textOutBoxColor = color;
        break;
    }
  }
}
