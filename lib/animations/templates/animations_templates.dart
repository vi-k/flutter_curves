import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../animation/animation_settings.dart';
import '../animation/transformers/box_radius_transformer.dart';
import '../animation/transformers/color_transformer.dart';
import '../animation/transformers/matrix_transformer.dart';
import '../animation/transformers/rotate_transformer.dart';
import '../animation/transformers/scale_transformer.dart';
import '../animation/transformers/skew_transformer.dart';
import '../animation/transformers/translate_transformer.dart';
import '../animation/what.dart';

final List<AnimationSettings> defaultFirstAnimations = [
  animationsTemplates[0],
  animationsTemplates[3],
  animationsTemplates[6],
  animationsTemplates[8],
];

final List<AnimationSettings> defaultSecondAnimations = [
  animationsTemplates[11],
  animationsTemplates[9],
  animationsTemplates[10],
  animationsTemplates[14],
];

final List<AnimationSettings> animationsTemplates = [
  const AnimationSettings(
    transformers: [
      TranslateXTransformer(),
    ],
    rect: Rect.fromLTRB(-1, -1, 0, 1),
    what: What(
      fill: true,
      text: 'AB',
    ),
  ),
  const AnimationSettings(
    transformers: [
      TranslateYTransformer(end: -1),
    ],
    rect: Rect.fromLTRB(-1, 0, 1, 1),
    what: What(
      fill: true,
      text: 'ABC',
    ),
  ),
  const AnimationSettings(
    transformers: [
      TranslateXTransformer(end: 2.25),
    ],
    what: What(
      fill: true,
      text: 'ABCDEF',
    ),
  ),
  const AnimationSettings(
    transformers: [
      ScaleTransformer(),
    ],
    what: What(
      fill: true,
      text: 'ABCDEF',
    ),
  ),
  const AnimationSettings(
    transformers: [
      ScaleTransformer(
        begin: 1,
        end: 1.5,
        alignment: Alignment.center,
      ),
    ],
    what: What(
      fill: true,
      text: 'ABCDEF',
    ),
  ),
  const AnimationSettings(
    transformers: [
      ScaleYTransformer(
        alignment: Alignment.bottomCenter,
      ),
    ],
    what: What(
      fill: true,
      text: 'ABCDEF',
    ),
  ),
  const AnimationSettings(
    transformers: [
      RotateTransformer(end: math.pi / 2),
    ],
    what: What(
      fill: true,
      text: 'ABCDEF',
    ),
  ),
  const AnimationSettings(
    transformers: [
      RotateTransformer(end: -math.pi),
    ],
    what: What(
      fill: true,
      text: 'ABCDEF',
    ),
  ),
  const AnimationSettings(
    transformers: [
      ColorTransformer(
        colorType: ColorType.box,
        begin: DraftColor.box(0),
        end: DraftColor.box(),
      ),
    ],
    what: What(
      fill: true,
      text: 'ABCDEF',
    ),
  ),
  const AnimationSettings(
    transformers: [
      ColorTransformer(
        colorType: ColorType.box,
        begin: DraftColor.box(),
        end: DraftColor.alternate(),
      ),
    ],
    what: What(
      fill: true,
      text: 'ABCDEF',
    ),
  ),
  const AnimationSettings(
    rect: Rect.fromLTRB(-1, -0.5, 1, 0.5),
    transformers: [
      SkewYTransformer(
        begin: 0.5,
        end: -0.5,
      ),
    ],
    what: What(
      fill: true,
      text: 'AB',
    ),
  ),
  const AnimationSettings(
    transformers: [
      BoxRadiusTransformer(
        begin: BorderRadius.zero,
        end: BorderRadius.all(Radius.circular(1)),
      ),
    ],
    what: What(
      fill: true,
      text: 'ABC',
    ),
  ),
  const AnimationSettings(
    transformers: [
      BoxRadiusTransformer(
        begin: BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(2),
          bottomRight: Radius.circular(0),
          bottomLeft: Radius.circular(2),
        ),
        end: BorderRadius.only(
          topLeft: Radius.circular(2),
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(2),
          bottomLeft: Radius.circular(0),
        ),
      ),
    ],
    what: What(
      fill: true,
      text: 'A',
    ),
  ),
  const AnimationSettings(
    transformers: [
      BoxRadiusTransformer(
        begin: BorderRadius.only(
          topRight: Radius.circular(2),
        ),
        end: BorderRadius.only(
          bottomRight: Radius.circular(2),
        ),
      ),
    ],
    what: What(
      fill: true,
      text: 'A',
    ),
  ),
  AnimationSettings(
    transformers: [
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
    ],
    what: const What(
      fill: true,
      text: 'ABCDEF',
    ),
  ),
  AnimationSettings(
    transformers: [
      MatrixTransformer(
        begin: 0 * math.pi / 180,
        end: -90 * math.pi / 180,
        matrix: (value) => (Matrix4.zero()
              ..setValues(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0.05, 0, 0, 0, 1)
              ..translate(0.0, 1)
              ..rotateX(value)
              ..translate(0.0, -1, 0))
            .storage,
      ),
    ],
    what: const What(
      fill: true,
      text: 'ABCDEF',
    ),
  ),
  AnimationSettings(
    transformers: [
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
    ],
    what: const What(
      fill: true,
      text: 'ABCDEF',
    ),
  ),
  AnimationSettings(
    rect: const Rect.fromLTRB(-1, -2, 1, 1),
    transformers: [
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
      const ColorTransformer(
        colorType: ColorType.textOutBox,
        begin: DraftColor.textOutBox(),
        end: DraftColor.textOutBox(0),
      ),
    ],
    what: const What(
      text: 'A LONG\nTIME AGO\nIN A GALAXY\nFAR, FAR AWAY...',
      fontSize: 0.4,
    ),
  ),
  AnimationSettings(
    transformers: [
      MatrixTransformer(
        begin: 0 * math.pi / 180,
        end: -360 * math.pi / 180,
        matrix: (value) => (Matrix4.zero()
              ..setValues(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0.5, 0, 0, 0, 1)
              ..translate(0.0, 0, 2)
              ..rotateY(value)
              ..translate(0.0, 0, -2)
              ..rotateZ(-2.5 * value)
            //
            )
            .storage,
      ),
    ],
    what: const What(
      icon: Icons.add,
      fontSize: 1.6,
    ),
  ),
  const AnimationSettings(
    transformers: [
      RotateTransformer(
        end: 315 * math.pi / 180,
      ),
      ColorTransformer(
        colorType: ColorType.textOutBox,
        begin: DraftColor.textOutBox(),
        end: DraftColor.textOutBox(0.1),
      ),
    ],
    what: What(
      icon: Icons.add,
      fontSize: 1.6,
    ),
  ),
];
