import 'package:flutter/painting.dart';

class AnimationState {
  final Canvas canvas;
  final double px;
  final Rect rect;
  final Color boxColor;
  final Color alternateColor;
  final Color textOnBoxColor;
  final Color textOutBoxColor;
  RRect finalizedRect;
  Color finalizedBoxColor;
  Color finalizedTextOnBoxColor;
  Color finalizedTextOutBoxColor;

  AnimationState({
    required this.canvas,
    required this.px,
    required this.rect,
    required this.boxColor,
    required this.alternateColor,
    required this.textOnBoxColor,
    required this.textOutBoxColor,
  })  : finalizedBoxColor = boxColor,
        finalizedTextOnBoxColor = textOnBoxColor,
        finalizedTextOutBoxColor = textOutBoxColor,
        finalizedRect =
            RRect.fromRectAndRadius(rect, const Radius.circular(0.15));
}
