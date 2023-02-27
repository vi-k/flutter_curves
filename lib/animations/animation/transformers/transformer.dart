import 'package:flutter/material.dart';

import '../animation_state.dart';

abstract class Transformer<T> {
  final T begin;
  final T end;

  const Transformer({
    required this.begin,
    required this.end,
  });

  T transform(AnimationState state, double value);

  void prepare(AnimationState state) {}

  void calcValueAndExecute(AnimationState state, double value) {
    execute(state, transform(state, value));
  }

  void execute(AnimationState state, T transformedValue);

  void finalize(AnimationState state) {}
}

abstract class DoubleTypeTransformer extends Transformer<double> {
  const DoubleTypeTransformer({
    required super.begin,
    required super.end,
  });

  @override
  double transform(AnimationState state, double value) =>
      begin + value * (end - begin);
}

mixin HasError {
  bool get showError;

  bool hasError(double value) => false;
}

mixin HasAlignment<T> on Transformer<T> {
  Alignment get alignment;

  @override
  void prepare(AnimationState state) {
    state.canvas.translate(alignment.x, alignment.y);
    super.prepare(state);
  }

  @override
  void finalize(AnimationState state) {
    state.canvas.translate(-alignment.x, -alignment.y);
    super.prepare(state);
  }
}

mixin HasAxis {
  Axis? get axis;
}
