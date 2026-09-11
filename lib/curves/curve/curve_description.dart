import 'package:flutter/animation.dart';

import '../templates/curves_templates.dart';

/// Describes [curve] for the readout under the graph.
///
/// Not `curve.toString()`, for two reasons. `Curve` does not override it, so
/// a curve with no parameters of its own — `Curves.linear` and most of the
/// catalogue — prints as `Instance of '…'`, and in a release build that is
/// the minified name. And a release build compiled to WebAssembly prints the
/// minified form even for the curves that do override `toString`, so the
/// readout of a `Cubic` reads `Instance of 'minified:Class1959'` there while
/// the same code compiled to JavaScript reads `Cubic(0.25, 0.10, …)`.
///
/// The parameters are what the readout is for, so they are formatted here
/// rather than asked of the object.
String describeCurve(Curve curve) => switch (curve) {
  Cubic(:final a, :final b, :final c, :final d) =>
    'Cubic(${_n(a)}, ${_n(b)}, ${_n(c)}, ${_n(d)})',
  ThreePointCubic(
    :final a1,
    :final b1,
    :final midpoint,
    :final a2,
    :final b2,
  ) =>
    'ThreePointCubic(${_xy(a1)}, ${_xy(b1)}, ${_xy(midpoint)}, '
        '${_xy(a2)}, ${_xy(b2)})',
  ElasticInCurve(:final period) => 'ElasticInCurve(${_n(period)})',
  ElasticOutCurve(:final period) => 'ElasticOutCurve(${_n(period)})',
  ElasticInOutCurve(:final period) => 'ElasticInOutCurve(${_n(period)})',
  // Everything left takes no parameters, so its name is all there is to say.
  // Every such curve on screen comes from the catalogue, which is where the
  // name comes from.
  _ => findNameByCurve(curve) ?? 'Curve',
};

String _n(double value) => value.toStringAsFixed(2);

String _xy(Offset point) => '(${_n(point.dx)}, ${_n(point.dy)})';
