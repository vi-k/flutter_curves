import 'dart:typed_data';

import 'package:flutter/painting.dart';

import '../animation_state.dart';
import 'transformer.dart';

class MatrixTransformer extends DoubleTypeTransformer with HasAlignment {
  @override
  final Alignment alignment;
  final Axis? axis;
  final Float64List Function(double value) matrix;

  const MatrixTransformer({
    required this.matrix,
    Alignment? alignment,
    this.axis,
    double? begin,
    double? end,
  })  : alignment = alignment ?? Alignment.center,
        super(
          begin: begin ?? 0,
          end: end ?? 1,
        );

  @override
  void execute(AnimationState state, double transformedValue) {
    state.canvas.transform(matrix(transformedValue));
  }

  // [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]
  // [0.0, 1.0, 0.0, 0.0, -1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0]
  // scale_x  skew_y   ?  pers_x
  // skew_x   scale_y  ?  persy
  // ?        ?        ?  pers_z
  // tra_x    tra_y    ?
  // state.canvas.transform(Float64List.fromList([
  //   1, // scale_x
  //   1, // skew_y
  //   0, // ?
  //   0, // pers_x
  //   -1, // skew_x
  //   1, // scale_y
  //   0, // ?
  //   0, // pers_y
  //   0, // ?
  //   0, // ?
  //   1, // ?
  //   0, // pers_z
  //   0, // translate_x
  //   0, // translate_y
  //   0, // ?
  //   1,
  // ]));
}
