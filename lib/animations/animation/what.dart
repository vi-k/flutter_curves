import 'package:flutter/widgets.dart';

class What {
  final bool fill;
  final bool border;
  final String? text;
  final double fontSize;
  final IconData? icon;

  const What({
    this.fill = false,
    this.border = false,
    this.text,
    this.fontSize = 0.8,
    this.icon,
  });
}
