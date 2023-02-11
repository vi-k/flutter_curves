import 'dart:ui';

import 'package:flutter/material.dart';

import 'animation_box.dart';

class MoveBox extends AnimationBox {
  final Axis axis;

  const MoveBox({
    super.key,
    required super.animation,
    required super.curve,
    required super.flipped,
    super.fill = true,
    this.axis = Axis.horizontal,
  });

  @override
  void doPaint(Canvas canvas, double value, double px, Paint paint) {
    if (axis == Axis.horizontal) {
      canvas
        ..translate(value, 0)
        ..drawRect(
          const Rect.fromLTRB(-1, -1, 0, 1),
          paint,
        );
    } else {
      canvas
        ..translate(0, value)
        ..drawRect(
          const Rect.fromLTRB(-1, -1, 1, 0),
          paint,
        );
    }
  }
}
