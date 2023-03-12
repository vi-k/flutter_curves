import 'package:flutter/material.dart';

import '../motion_state.dart';

abstract class MotionTransformer<T> {
  const MotionTransformer({
    required this.begin,
    required this.end,
  });

  final T begin;
  final T end;

  T transformedValue(MotionState state, double value);

  void prepare(MotionState state) {}

  void calculateAndTransform(MotionState state, double value) {
    transform(state, transformedValue(state, value));
  }

  void transform(MotionState state, T transformedValue);

  void finalize(MotionState state) {}
}

abstract class MotionTransformerDouble extends MotionTransformer<double> {
  const MotionTransformerDouble({
    required super.begin,
    required super.end,
  });

  @override
  double transformedValue(MotionState state, double value) =>
      begin + value * (end - begin);
}

mixin HasAlignment<T> on MotionTransformer<T> {
  Alignment get alignment;

  @override
  void prepare(MotionState state) {
    state.canvas.translate(alignment.x, alignment.y);
    super.prepare(state);
  }

  @override
  void finalize(MotionState state) {
    state.canvas.translate(-alignment.x, -alignment.y);
    super.prepare(state);
  }
}

mixin HasAxis {
  Axis? get axis;
}
