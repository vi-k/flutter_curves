import 'package:flutter/material.dart';

import '../color_type.dart';
import 'motion_text.dart';

class MotionIcon extends MotionText {
  const MotionIcon(
    this.icon, {
    super.fontSize = 0.8,
    super.color = const DraftColor.textOnBox(),
  }) : super('');

  final IconData icon;

  @override
  String get text => String.fromCharCode(icon.codePoint);

  @override
  String? get fontFamily => icon.fontFamily;
}
