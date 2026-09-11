import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_curves/motions/export.dart';

MotionState createMotionState({
  Canvas? canvas,
  double px = 0.01,
  Rect rect = const Rect.fromLTRB(-1, -1, 1, 1),
  BorderRadius? borderRadius,
  Brightness brightness = Brightness.light,
  Color boxColor = const Color(0xff112233),
  Color textOnBoxColor = const Color(0xff445566),
  Color textOutBoxColor = const Color(0xff778899),
  Color alternateColor = const Color(0xffaabbcc),
}) => MotionState(
  canvas: canvas ?? Canvas(ui.PictureRecorder()),
  px: px,
  rect: rect,
  borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(0.15)),
  brightness: brightness,
  boxColor: boxColor,
  textOnBoxColor: textOnBoxColor,
  textOutBoxColor: textOutBoxColor,
  alternateColor: alternateColor,
);

void applyTransformer(
  MotionTransformer<Object> transformer,
  MotionState state,
  double value,
) {
  transformer
    ..prepare(state)
    ..calculateAndTransform(state, value)
    ..finalize(state);
}

Future<ui.Image> renderCanvas(
  void Function(Canvas canvas) draw, {
  int size = 40,
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  draw(canvas);
  final picture = recorder.endRecording();
  return picture.toImage(size, size);
}

Future<Color> readPixel(ui.Image image, int x, int y) async {
  final data = await image.toByteData();
  if (data == null) {
    throw StateError('The image did not produce pixel data');
  }

  final offset = (y * image.width + x) * 4;
  return Color.fromARGB(
    data.getUint8(offset + 3),
    data.getUint8(offset),
    data.getUint8(offset + 1),
    data.getUint8(offset + 2),
  );
}

Future<Color> transformedSquarePixel(
  MotionTransformer<Object> transformer,
  double value, {
  required int x,
  required int y,
}) async {
  final image = await renderCanvas((canvas) {
    canvas.translate(10, 10);
    final state = createMotionState(canvas: canvas);
    applyTransformer(transformer, state, value);
    canvas.drawRect(const Rect.fromLTWH(0, 0, 4, 4), Paint());
  });
  final pixel = await readPixel(image, x, y);
  image.dispose();
  return pixel;
}
