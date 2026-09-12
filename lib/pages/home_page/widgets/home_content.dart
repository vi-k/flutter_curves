import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../curves/widgets/curve_box.dart';
import '../home_scope.dart';
import 'motions_band.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = HomeScope.access.of(context);
    final firstMotions = HomeScope.access.select(
      context,
      (state) => state.firstMotions,
    );
    final secondMotions = HomeScope.access.select(
      context,
      (state) => state.secondMotions,
    );
    final curve = HomeScope.access.select(context, (state) => state.curve);
    final flipped = HomeScope.access.select(context, (state) => state.flipped);

    return Padding(
      padding: const EdgeInsets.all(Const.defaultPadding),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final count = math.max(firstMotions.length, secondMotions.length);

          final curveM = count + (count - 1) * Const.separatorFactor;
          final size =
              (firstMotions.isEmpty ? 0 : 1) +
              Const.separatorFactor * 2 +
              curveM +
              Const.separatorFactor * 2 +
              (secondMotions.isEmpty ? 0 : 1);

          late Axis direction;
          late double boxSize;

          if (constraints.maxWidth.isFinite) {
            boxSize = constraints.maxWidth / size;
            direction = Axis.horizontal;
          }

          boxSize = math.min(boxSize, Const.maxBoxSize);

          if (constraints.maxHeight.isFinite) {
            var vBoxSize = constraints.maxHeight / size;
            vBoxSize = math.min(vBoxSize, Const.maxBoxSize);

            if (constraints.maxWidth.isFinite && vBoxSize > boxSize) {
              direction = Axis.vertical;
              final hBoxSize = constraints.maxWidth / curveM;
              boxSize = math.min(vBoxSize, hBoxSize);
            } else {
              final vBoxSize = constraints.maxHeight / curveM;

              if (!constraints.maxWidth.isFinite || vBoxSize < boxSize) {
                direction = Axis.horizontal;
                boxSize = vBoxSize;
              }
            }
          }

          final separatorSize = boxSize * Const.separatorFactor;
          final curveHeight = curveM * boxSize;
          final curveWidth =
              curveHeight /
              Const.curveVerticalMultiplier *
              Const.curveHorizontalMultiplier;
          final separator = SizedBox.square(dimension: 2 * separatorSize);

          var content = [
            MotionsBand(
              motions: firstMotions,
              heroTag: 'first-motions',
              count: count,
              boxSize: boxSize,
              separatorSize: separatorSize,
              direction: direction == Axis.horizontal
                  ? Axis.vertical
                  : Axis.horizontal,
              animation: scope.motionController.animation,
              curve: curve,
              flipped: flipped,
              onTap: scope.selectFirstMotion,
            ),
            separator,
            SizedBox(
              width: curveWidth,
              height: curveHeight,
              child: const _Curve(),
            ),
            separator,
            MotionsBand(
              motions: secondMotions,
              heroTag: 'second-motions',
              count: count,
              boxSize: boxSize,
              separatorSize: separatorSize,
              direction: direction == Axis.horizontal
                  ? Axis.vertical
                  : Axis.horizontal,
              animation: scope.motionController.animation,
              curve: curve,
              flipped: flipped,
              onTap: scope.selectSecondMotion,
            ),
          ];

          if (direction == Axis.horizontal) {
            content = content.reversed.toList();
          }

          return Flex(
            direction: direction,
            mainAxisAlignment: MainAxisAlignment.center,
            children: content,
          );
        },
      ),
    );
  }
}

class _Curve extends StatelessWidget {
  const _Curve();

  @override
  Widget build(BuildContext context) => CurveBox(
    animation: HomeScope.access.of(context).motionController.animation,
    curve: HomeScope.access.select(context, (state) => state.curve),
    flipped: HomeScope.access.select(context, (state) => state.flipped),
    horizontalMultiplier: Const.curveHorizontalMultiplier,
    verticalMultiplier: Const.curveVerticalMultiplier,
  );
}
