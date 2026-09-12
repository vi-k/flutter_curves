import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_curves/motions/export.dart';
import 'package:flutter_test/flutter_test.dart';

import 'motion_test_helpers.dart';

class _DoubleTransformer extends MotionTransformerDouble {
  const _DoubleTransformer({required super.begin, required super.end});

  @override
  void transform(MotionState state, double transformedValue) {}
}

mixin _RecordingStage on MotionTransformer<double> {
  List<String> get stages;

  @override
  void prepare(MotionState state) {
    stages.add('prepare');
    super.prepare(state);
  }

  @override
  void finalize(MotionState state) {
    stages.add('finalize');
    super.finalize(state);
  }
}

// HasAlignment is applied last, so its super is the recording mixin: what
// reaches the recorder is what the alignment mixin passed down.
class _AlignedOverRecording extends MotionTransformerDouble
    with _RecordingStage, HasAlignment {
  _AlignedOverRecording(this.stages) : super(begin: 0, end: 1);

  @override
  final List<String> stages;

  @override
  Alignment get alignment => Alignment.center;

  @override
  void transform(MotionState state, double transformedValue) {}
}

void main() {
  test('a double transformer interpolates between its endpoints', () {
    const transformer = _DoubleTransformer(begin: -2, end: 6);
    final state = createMotionState();

    expect(transformer.transformedValue(state, 0), -2);
    expect(transformer.transformedValue(state, 0.25), 0);
    expect(transformer.transformedValue(state, 1), 6);
  });

  test('a border radius transformer interpolates each corner', () {
    const transformer = BorderRadiusTransformer(
      begin: BorderRadius.zero,
      end: BorderRadius.only(
        topLeft: Radius.circular(4),
        bottomRight: Radius.circular(8),
      ),
    );

    final result = transformer.transformedValue(createMotionState(), 0.25);

    expect(result.topLeft.x, 1);
    expect(result.bottomRight.x, 2);
    expect(result.topRight, Radius.zero);
  });

  test('translation follows the selected axis', () async {
    final horizontal = await transformedSquarePixel(
      const TranslateTransformer(begin: 2, end: 2, axis: Axis.horizontal),
      0,
      x: 12,
      y: 11,
    );
    final vertical = await transformedSquarePixel(
      const TranslateTransformer(begin: 2, end: 2, axis: Axis.vertical),
      0,
      x: 11,
      y: 12,
    );
    final diagonal = await transformedSquarePixel(
      const TranslateTransformer(begin: 2, end: 2),
      0,
      x: 12,
      y: 12,
    );

    expect(horizontal.a, greaterThan(0));
    expect(vertical.a, greaterThan(0));
    expect(diagonal, const Color(0xff000000));
  });

  test('axis-specific transformer constructors select their axis', () {
    expect(const TranslateXTransformer().axis, Axis.horizontal);
    expect(const TranslateYTransformer().axis, Axis.vertical);
    expect(const ScaleXTransformer().axis, Axis.horizontal);
    expect(const ScaleYTransformer().axis, Axis.vertical);
    expect(const SkewXTransformer().axis, Axis.horizontal);
    expect(const SkewYTransformer().axis, Axis.vertical);
  });

  test('scale follows the selected axis', () async {
    final horizontal = await transformedSquarePixel(
      const ScaleTransformer(begin: 2, end: 2, axis: Axis.horizontal),
      0,
      x: 15,
      y: 11,
    );
    final horizontalOutside = await transformedSquarePixel(
      const ScaleTransformer(begin: 2, end: 2, axis: Axis.horizontal),
      0,
      x: 11,
      y: 15,
    );
    final vertical = await transformedSquarePixel(
      const ScaleTransformer(begin: 2, end: 2, axis: Axis.vertical),
      0,
      x: 11,
      y: 15,
    );

    expect(horizontal, const Color(0xff000000));
    expect(horizontalOutside, const Color(0x00000000));
    expect(vertical, const Color(0xff000000));
  });

  test('scale prepares around its alignment point', () async {
    final image = await renderCanvas((canvas) {
      canvas.translate(10, 10);
      final state = createMotionState(canvas: canvas);
      const transformer = ScaleTransformer(alignment: Alignment(2, 0));

      transformer.prepare(state);
      canvas.drawRect(const Rect.fromLTWH(0, 0, 2, 2), Paint());
    });

    expect(await readPixel(image, 11, 11), const Color(0x00000000));
    expect(await readPixel(image, 12, 11), const Color(0xff000000));
    image.dispose();
  });

  test('rotation turns a square around the origin', () async {
    final image = await renderCanvas((canvas) {
      canvas.translate(10, 10);
      final state = createMotionState(canvas: canvas);
      applyTransformer(
        const RotateTransformer(begin: math.pi / 2, end: math.pi / 2),
        state,
        0,
      );
      canvas.drawRect(const Rect.fromLTWH(1, 0, 2, 1), Paint());
    });

    expect(await readPixel(image, 9, 11), const Color(0xff000000));
    expect(await readPixel(image, 11, 11), const Color(0x00000000));
    image.dispose();
  });

  test('skew follows the selected axis', () async {
    final horizontal = await transformedSquarePixel(
      const SkewTransformer(begin: 1, end: 1, axis: Axis.horizontal),
      0,
      x: 17,
      y: 13,
    );
    final vertical = await transformedSquarePixel(
      const SkewTransformer(begin: 1, end: 1, axis: Axis.vertical),
      0,
      x: 13,
      y: 17,
    );

    expect(horizontal.a, greaterThan(0));
    expect(vertical.a, greaterThan(0));
  });

  test('fade scales the alpha of each selected initial color', () {
    final state = createMotionState(
      boxColor: const Color(0xff102030),
      textOnBoxColor: const Color(0xff405060),
      textOutBoxColor: const Color(0xff708090),
      alternateColor: const Color(0xffa0b0c0),
    );

    const FadeTransformer(
      colors: {ObjectColor.box, ObjectColor.textOutBox},
      begin: 0,
      end: 1,
    ).transform(state, 0.25);

    expect(state.boxColor.a, 0.25);
    expect(state.boxColor.r, const Color(0xff102030).r);
    expect(state.textOutBoxColor.a, 0.25);
    expect(state.textOutBoxColor.b, const Color(0xff708090).b);
    expect(state.textOnBoxColor, const Color(0xff405060));
  });

  test('fade clamps values outside the opacity range', () {
    final state = createMotionState(boxColor: const Color(0x80102030));
    const transformer = FadeTransformer(begin: -1, end: -1);

    transformer.transform(state, transformer.begin);

    expect(state.boxColor, const Color(0x00102030));

    final upperState = createMotionState(boxColor: const Color(0x80102030));
    const upperTransformer = FadeTransformer(begin: 2, end: 2);

    upperTransformer.transform(upperState, upperTransformer.begin);

    expect(upperState.boxColor, const Color(0x80102030));
  });

  test('color interpolation writes the selected object color', () {
    final state = createMotionState(
      boxColor: const Color(0xffff0000),
      alternateColor: const Color(0xff0000ff),
    );
    const transformer = ColorTransformer(
      color: ObjectColor.box,
      begin: DraftColor.box(),
      end: DraftColor.alternate(),
    );

    applyTransformer(transformer, state, 0.5);

    expect(state.boxColor.r, 0.5);
    expect(state.boxColor.g, 0);
    expect(state.boxColor.b, 0.5);
  });

  test(
    'matrix transformer applies the matrix produced for the value',
    () async {
      final image = await renderCanvas((canvas) {
        canvas.translate(10, 10);
        final state = createMotionState(canvas: canvas);
        const translation = 3.0;
        final transformer = MatrixTransformer(
          begin: 0,
          end: 0,
          matrix: (_) => Float64List.fromList([
            1,
            0,
            0,
            0,
            0,
            1,
            0,
            0,
            0,
            0,
            1,
            0,
            translation,
            0,
            0,
            1,
          ]),
        );
        applyTransformer(transformer, state, 0);
        canvas.drawRect(const Rect.fromLTWH(0, 0, 2, 2), Paint());
      });

      expect(await readPixel(image, 13, 11), const Color(0xff000000));
      expect(await readPixel(image, 11, 11), const Color(0x00000000));
      image.dispose();
    },
  );

  // Every mixin stage has to hand the call down the chain it was given.
  // With a single mixin a swapped super() is invisible: the base does
  // nothing either way. Stacking two makes the swap show up.
  test('the alignment mixin passes finalize down the chain', () {
    final stages = <String>[];
    final transformer = _AlignedOverRecording(stages);
    final state = createMotionState();

    transformer
      ..prepare(state)
      ..finalize(state);

    expect(stages, ['prepare', 'finalize']);
  });

  test('every transformer that reads an axis carries the axis marker', () {
    expect(const TranslateTransformer(), isA<HasAxis>());
    expect(const ScaleTransformer(), isA<HasAxis>());
    expect(const SkewTransformer(), isA<HasAxis>());
  });
}
