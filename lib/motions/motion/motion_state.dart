import 'dart:ui';

import 'package:flutter/painting.dart';

class MotionState {
  MotionState({
    required this.canvas,
    required this.px,
    required this.rect,
    this.borderRadius = const BorderRadius.all(Radius.circular(defaultCorner)),
    required this.brightness,
    required this.boxColor,
    required this.textOnBoxColor,
    required this.textOutBoxColor,
    required this.alternateColor,
  })  : initialRect = rect,
        initialBorderRadius = borderRadius,
        initialBoxColor = boxColor,
        initialTextOnBoxColor = textOnBoxColor,
        initialTextOutBoxColor = textOutBoxColor;

  final Canvas canvas;
  final double px;
  final Rect initialRect;
  BorderRadius initialBorderRadius;
  final Brightness brightness;
  final Color initialBoxColor;
  final Color initialTextOnBoxColor;
  final Color initialTextOutBoxColor;
  final Color alternateColor;
  Rect rect;
  BorderRadius borderRadius;
  Color boxColor;
  Color textOnBoxColor;
  Color textOutBoxColor;

  static const double defaultCorner = 0.15;

  RRect get rrect => borderRadius.toRRect(rect);

  MotionState save([Rect? rect]) {
    canvas.save();

    return MotionState(
      canvas: canvas,
      px: px,
      rect: rect ?? this.rect,
      borderRadius: borderRadius,
      brightness: brightness,
      boxColor: boxColor,
      textOnBoxColor: textOnBoxColor,
      textOutBoxColor: textOutBoxColor,
      alternateColor: alternateColor,
    );
  }

  void restore() {
    canvas.restore();
  }
}
