import 'package:flutter/animation.dart';
import 'package:flutter_curves/curves/export.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a cubic is described by its four coefficients', () {
    expect(describeCurve(Curves.ease), 'Cubic(0.25, 0.10, 0.25, 1.00)');
    expect(
      describeCurve(const Cubic(-0.6, 0, 1.6, 1)),
      'Cubic(-0.60, 0.00, 1.60, 1.00)',
    );
  });

  test('a three point cubic is described by its five points', () {
    expect(
      describeCurve(Curves.easeInOutCubicEmphasized),
      startsWith('ThreePointCubic(('),
    );
  });

  test('an elastic curve is described by its period', () {
    expect(describeCurve(const ElasticInCurve(0.25)), 'ElasticInCurve(0.25)');
    expect(describeCurve(const ElasticOutCurve(1)), 'ElasticOutCurve(1.00)');
    expect(
      describeCurve(const ElasticInOutCurve(0.125)),
      'ElasticInOutCurve(0.13)',
    );
  });

  test('a curve without parameters is described by its catalogue name', () {
    // `toString()` would answer `Instance of '_Linear'` here, and the
    // minified form of that in a release build.
    expect(describeCurve(Curves.linear), 'Curves.linear');
    expect(describeCurve(Curves.bounceOut), 'Curves.bounceOut');
  });

  test('a curve the catalogue does not know falls back to a plain word', () {
    expect(describeCurve(const SawTooth(3)), 'Curve');
  });
}
