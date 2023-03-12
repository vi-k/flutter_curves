import 'dart:math' as math;

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

import '../export.dart';

final IList<MotionObject> defaultFirstMotions = IListConst([
  motionsTemplates[0], // translate
  motionsTemplates[6], // scale
  motionsTemplates[12], // rotate
  motionsTemplates[15], // skew
]);

final IList<MotionObject> defaultSecondMotions = IListConst([
  motionsTemplates[18], // fade (color)
  motionsTemplates[19], // color
  motionsTemplates[22], // border radius
  motionsTemplates[28], // matrix
]);

final IList<MotionObject> motionsTemplates = IListConst([
  const Motions(
    rect: RectExt.left(),
    transformers: IListConst([
      TranslateXTransformer(),
    ]),
    children: IListConst([
      MotionFill(),
      MotionText('AB'),
      Motions(
        rect: Rect.fromLTWH(-1, 0, 2, 1),
        transformers: IListConst([
          TranslateYTransformer(
            begin: 0,
            end: -1,
          ),
        ]),
        children: IListConst([
          // MotionFill(),
          // MotionBorder(color: DraftColor.alternate()),
          // MotionText('ABC'),
        ]),
      ),
    ]),
  ),
  const Motions(
    rect: RectExt.bottom(),
    transformers: IListConst([
      TranslateYTransformer(end: -1),
    ]),
    children: IListConst([
      MotionFill(),
      MotionText('ABC'),
    ]),
  ),
  const Motions(
    transformers: IListConst([
      TranslateXTransformer(end: 2.25),
    ]),
    children: IListConst([
      MotionFill(),
      MotionText('ABCDEF'),
    ]),
  ),
  const Motions(
    transformers: IListConst([
      TranslateXTransformer(
        begin: -2.25,
        end: 0,
      ),
    ]),
    children: IListConst([
      MotionFill(),
      MotionText('ABCDEF'),
    ]),
  ),
  const Motions(
    transformers: IListConst([
      TranslateYTransformer(end: 2.25),
    ]),
    children: IListConst([
      MotionFill(),
      MotionText('ABCDEF'),
    ]),
  ),
  const Motions(
    transformers: IListConst([
      TranslateYTransformer(
        begin: -2.25,
        end: 0,
      ),
    ]),
    children: IListConst([
      MotionFill(),
      MotionText('ABCDEF'),
    ]),
  ),
  const Motions(
    transformers: IListConst([
      ScaleTransformer(),
    ]),
    children: IListConst([
      MotionFill(),
      MotionText('ABCDEF'),
    ]),
  ),
  const Motions(
    transformers: IListConst([
      ScaleTransformer(),
      FadeTransformer(),
    ]),
    children: IListConst([
      MotionFill(),
      MotionText('ABCDEF'),
    ]),
  ),
  const Motions(
    transformers: IListConst([
      ScaleTransformer(),
      RotateTransformer(
        begin: 0,
        end: 2 * math.pi,
      ),
    ]),
    children: IListConst([
      MotionFill(),
      MotionText('ABCDEF'),
    ]),
  ),
  const Motions(
    transformers: IListConst([
      ScaleTransformer(
        begin: 1,
        end: 1.5,
        alignment: Alignment.center,
      ),
    ]),
    children: IListConst([
      MotionFill(),
      MotionText('ABCDEF'),
    ]),
  ),
  const Motions(
    transformers: IListConst([
      ScaleYTransformer(
        alignment: Alignment.bottomCenter,
      ),
    ]),
    children: IListConst([
      MotionFill(),
      MotionText('ABCDEF'),
    ]),
  ),
  const Motions(
    transformers: IListConst([
      ScaleXTransformer(
        alignment: Alignment.centerLeft,
      ),
    ]),
    children: IListConst([
      MotionFill(),
      MotionText('ABCDEF'),
    ]),
  ),
  const Motions(
    transformers: IListConst([
      RotateTransformer(end: math.pi / 2),
    ]),
    children: IListConst([
      MotionFill(),
      MotionText('ABCDEF'),
    ]),
  ),
  const Motions(
    transformers: IListConst([
      RotateTransformer(end: math.pi),
    ]),
    children: IListConst([
      MotionFill(),
      MotionText('ABCDEF'),
    ]),
  ),
  const Motions(
    transformers: IListConst([
      RotateTransformer(end: 2 * math.pi),
    ]),
    children: IListConst([
      MotionFill(),
      MotionText('ABCDEF'),
    ]),
  ),
  const Motions(
    rect: RectExt.center(width: 2),
    transformers: IListConst([
      SkewYTransformer(
        begin: 0.5,
        end: -0.5,
      ),
    ]),
    children: IListConst([
      MotionFill(),
      MotionText('AB'),
    ]),
  ),
  const Motions(
    rect: RectExt.center(width: 2),
    transformers: IListConst([
      SkewXTransformer(
        begin: 0.5,
        end: -0.5,
      ),
    ]),
    children: IListConst([
      MotionFill(),
      MotionText('AB'),
    ]),
  ),
  const Motions(
    rect: RectExt.left(),
    transformers: IListConst([
      SkewXTransformer(
        alignment: Alignment.bottomCenter,
        begin: 0,
        end: -0.5,
      ),
    ]),
    children: IListConst([
      MotionFill(),
      MotionText('AB'),
    ]),
  ),
  const Motions(
    transformers: IListConst([
      FadeTransformer(),
    ]),
    children: IListConst([
      MotionFill(),
      MotionText('ABCDEF'),
    ]),
  ),
  const Motions(
    transformers: IListConst([
      ColorTransformer(
        color: ObjectColor.box,
        begin: DraftColor.box(),
        end: DraftColor.alternate(),
      ),
    ]),
    children: IListConst([
      MotionFill(),
      MotionText('ABCDEF'),
    ]),
  ),
  const Motions(
    transformers: IListConst([
      ColorTransformer(
        color: ObjectColor.box,
        begin: DraftColor.box(),
        end: DraftColor.alternate(),
      ),
      ColorTransformer(
        color: ObjectColor.textOnBox,
        begin: DraftColor.textOnBox(),
        end: DraftColor.textOutBox(),
      ),
    ]),
    children: IListConst([
      MotionFill(),
      MotionText('ABCDEF'),
    ]),
  ),
  const Motions(
    transformers: IListConst([
      FadeTransformer(
        begin: 1,
        end: 0,
      ),
      ColorTransformer(
        color: ObjectColor.textOnBox,
        begin: DraftColor.textOnBox(),
        end: DraftColor.textOutBox(),
      ),
    ]),
    children: IListConst([
      MotionFill(),
      MotionText('ABCDEF'),
    ]),
  ),
  const Motions(
    rect: RectExt.center(width: 2),
    transformers: IListConst([
      BorderRadiusTransformer(
        begin: BorderRadius.zero,
        end: BorderRadius.all(Radius.circular(0.5)),
      ),
    ]),
    children: IListConst([
      MotionFill(),
      MotionText('ABC'),
    ]),
  ),
  const Motions(
    rect: RectExt.center(width: 2),
    transformers: IListConst([
      BorderRadiusTransformer(
        begin: BorderRadius.all(
          Radius.circular(0.5),
        ),
        end: BorderRadius.only(
          topRight: Radius.circular(0.5),
          topLeft: Radius.circular(0.5),
          bottomRight: Radius.circular(0.5),
        ),
      ),
    ]),
    children: IListConst([
      MotionFill(),
      MotionText('ABC'),
    ]),
  ),
  const Motions(
    rect: RectExt.center(width: 2),
    transformers: IListConst([
      BorderRadiusTransformer(
        begin: BorderRadius.only(
          topRight: Radius.circular(1),
          bottomLeft: Radius.circular(1),
        ),
        end: BorderRadius.only(
          topLeft: Radius.circular(1),
          bottomRight: Radius.circular(1),
        ),
      ),
    ]),
    children: IListConst([
      MotionFill(),
      MotionText('AB'),
    ]),
  ),
  const Motions(
    transformers: IListConst([
      BorderRadiusTransformer(
        begin: BorderRadius.zero,
        end: BorderRadius.all(Radius.circular(1)),
      ),
    ]),
    children: IListConst([
      MotionFill(),
      MotionText('AB'),
    ]),
  ),
  const Motions(
    transformers: IListConst([
      BorderRadiusTransformer(
        begin: BorderRadius.only(
          topRight: Radius.circular(2),
          bottomLeft: Radius.circular(2),
        ),
        end: BorderRadius.only(
          topLeft: Radius.circular(2),
          bottomRight: Radius.circular(2),
        ),
      ),
    ]),
    children: IListConst([
      MotionFill(),
      MotionText('A'),
    ]),
  ),
  const Motions(
    transformers: IListConst([
      BorderRadiusTransformer(
        begin: BorderRadius.only(
          topRight: Radius.circular(2),
        ),
        end: BorderRadius.only(
          bottomRight: Radius.circular(2),
        ),
      ),
    ]),
    children: IListConst([
      MotionFill(),
      MotionText('A'),
    ]),
  ),
  Motions(
    transformers: IListConst([
      MatrixTransformer(
        begin: 0 * math.pi / 180,
        end: -180 * math.pi / 180,
        matrix: (value) => (Matrix4.zero()
              ..setValues(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0.5, 0, 0, 0, 1)
              ..rotateZ(math.pi / 4)
              ..rotateX(value)
              ..rotateZ(-math.pi / 4))
            .storage,
      ),
    ]),
    children: const IListConst([
      MotionFill(),
      MotionText('ABCDEF'),
    ]),
  ),
  Motions(
    transformers: IListConst([
      MatrixTransformer(
        begin: 0 * math.pi / 180,
        end: -90 * math.pi / 180,
        matrix: (value) => (Matrix4.zero()
              ..setValues(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0.05, 0, 0, 0, 1)
              ..translate(0.0, 1)
              ..rotateX(value)
              ..translate(0.0, -1))
            .storage,
      ),
    ]),
    children: const IListConst([
      MotionFill(),
      MotionText('ABCDEF'),
    ]),
  ),
  Motions(
    transformers: IListConst([
      MatrixTransformer(
        begin: 0 * math.pi / 180,
        end: -180 * math.pi / 180,
        matrix: (value) => (Matrix4.zero()
              ..setValues(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0.5, 0, 0, 0, 1)
              ..translate(0.0, 0, 2)
              ..rotateY(value)
              ..translate(0.0, 0, -2))
            .storage,
      ),
    ]),
    children: const IListConst([
      MotionFill(),
      MotionText('ABCDEF'),
    ]),
  ),
  Motions(
    rect: const RectExt.center(width: 1.8, height: 1.8),
    transformers: IListConst([
      const BorderRadiusTransformer(
        begin: BorderRadius.all(Radius.circular(1)),
        end: BorderRadius.all(Radius.circular(1)),
      ),
      MatrixTransformer(
        begin: 0 * math.pi / 180,
        end: -180 * math.pi / 180,
        matrix: (value) => (Matrix4.zero()
              ..setValues(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0.5, 0, 0, 0, 1)
              ..translate(0.0, 0, 2)
              ..rotateY(value)
              ..translate(0.0, 0, -2)
              ..rotateZ(-2 * value))
            .storage,
      ),
      const FadeTransformer(
        begin: 1,
        end: 0.8,
      ),
    ]),
    children: const IListConst([
      MotionFill(),
      MotionText(
        'A',
        fontSize: 1.6,
      ),
    ]),
  ),
  Motions(
    rect: const RectExt.bottom(height: 3),
    transformers: IListConst([
      MatrixTransformer(
        begin: -2.2,
        end: 5,
        alignment: const Alignment(0, -1.25),
        matrix: (value) => (Matrix4.zero()
              ..setValues(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0.5, 0, 0, 0, 1)
              ..translate(0.0, 1, value)
              ..scale(1.5, 1, 1)
              ..translate(0.0, 1)
              ..rotateX(-90 * math.pi / 180)
              ..translate(0.0, -1)
            //
            )
            .storage,
      ),
      const FadeTransformer(
        begin: 1,
        end: 0,
      ),
    ]),
    children: const IListConst([
      MotionText(
        'A LONG\nTIME AGO\nIN A GALAXY\nFAR, FAR AWAY...',
        color: DraftColor.textOutBox(),
        fontSize: 0.4,
      ),
    ]),
  ),
]);
