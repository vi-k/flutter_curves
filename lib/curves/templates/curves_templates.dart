import 'package:flutter/animation.dart';

class MyCurves {
  MyCurves._();

  static const Map<String, Curve> _curves = {
    'Curves.linear': Curves.linear,
    'Curves.decelerate': Curves.decelerate,
    'Curves.fastLinearToSlowEaseIn': Curves.fastLinearToSlowEaseIn,
    'Curves.ease': Curves.ease,
    'Curves.easeIn': Curves.easeIn,
    'Curves.easeInToLinear': Curves.easeInToLinear,
    'Curves.easeInSine': Curves.easeInSine,
    'Curves.easeInQuad': Curves.easeInQuad,
    'Curves.easeInCubic': Curves.easeInCubic,
    'Curves.easeInQuart': Curves.easeInQuart,
    'Curves.easeInQuint': Curves.easeInQuint,
    'Curves.easeInExpo': Curves.easeInExpo,
    'Curves.easeInCirc': Curves.easeInCirc,
    'Curves.easeInBack': Curves.easeInBack,
    'Curves.easeOut': Curves.easeOut,
    'Curves.linearToEaseOut': Curves.linearToEaseOut,
    'Curves.easeOutSine': Curves.easeOutSine,
    'Curves.easeOutQuad': Curves.easeOutQuad,
    'Curves.easeOutCubic': Curves.easeOutCubic,
    'Curves.easeOutQuart': Curves.easeOutQuart,
    'Curves.easeOutQuint': Curves.easeOutQuint,
    'Curves.easeOutExpo': Curves.easeOutExpo,
    'Curves.easeOutCirc': Curves.easeOutCirc,
    'Curves.easeOutBack': Curves.easeOutBack,
    'Curves.easeInOut': Curves.easeInOut,
    'Curves.easeInOutSine': Curves.easeInOutSine,
    'Curves.easeInOutQuad': Curves.easeInOutQuad,
    'Curves.easeInOutCubic': Curves.easeInOutCubic,
    'Curves.easeInOutCubicEmphasized': Curves.easeInOutCubicEmphasized,
    'Curves.easeInOutCubicEmphasized2': ThreePointCubic(
      Offset(0, 0.2),
      Offset(0.2, 0.3),
      Offset(0.55, 0.3),
      Offset(0.9, 0.3),
      Offset(0.8, 0.25),
    ),
    'Curves.easeInOutCubicEmphasized3': ThreePointCubic(
      Offset(0, 0.2),
      Offset(0.2, 0.20),
      Offset(0.55, 0.25),
      Offset(1, 0.3),
      Offset(0.9, 0.25),
    ),
    'Curves.easeInOutQuart': Curves.easeInOutQuart,
    'Curves.easeInOutQuint': Curves.easeInOutQuint,
    'Curves.easeInOutExpo': Curves.easeInOutExpo,
    'Curves.easeInOutCirc': Curves.easeInOutCirc,
    'Curves.easeInOutBack': Curves.easeInOutBack,
    'Curves.fastOutSlowIn': Curves.fastOutSlowIn,
    'Curves.slowMiddle': Curves.slowMiddle,
    'Curves.bounceIn': Curves.bounceIn,
    'Curves.bounceOut': Curves.bounceOut,
    'Curves.bounceInOut': Curves.bounceInOut,
    'Curves.elasticIn': Curves.elasticIn,
    'Curves.elasticOut': Curves.elasticOut,
    'Curves.elasticInOut': Curves.elasticInOut,
  };

  static List<String>? _allCurves;
  static List<String> get allCurves =>
      _allCurves ??= List.unmodifiable(_curves.keys);

  static bool isElastic(Curve curve) =>
      curve is ElasticInCurve ||
      curve is ElasticOutCurve ||
      curve is ElasticInOutCurve;

  static Curve? findByName(String name) => _curves[name];

  static String? findByCurve(Curve curve) {
    for (final entry in _curves.entries) {
      final value = entry.value;
      if (identical(value, curve) ||
          curve is Cubic &&
              value is Cubic &&
              curve.a == value.a &&
              curve.b == value.b &&
              curve.c == value.c &&
              curve.d == value.d ||
          curve is ElasticInCurve &&
              value is ElasticInCurve &&
              curve.period == value.period ||
          curve is ElasticOutCurve &&
              value is ElasticOutCurve &&
              curve.period == value.period ||
          curve is ElasticInOutCurve &&
              value is ElasticInOutCurve &&
              curve.period == value.period) {
        return entry.key;
      }
    }

    return null;
  }
}
