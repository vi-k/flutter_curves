class Const {
  Const._();

  static const double defaultPadding = 8;
  static const double defaultRadius = 4;
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  // horizontal multiplier of the main curve
  static const double curveHorisontalMultiplier = 1.6;

  // vertical multiplier of the main curve
  static const double curveVerticalMultiplier = 1.6;

  // separator factor relative to the animation box's size
  static const double separatorFactor = 0.1;

  // border radius factor relative to the animation box's size
  static const double borderRadiusFactor = 0.1;
}
