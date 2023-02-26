import 'package:flutter/material.dart';

import '../../../animations/export.dart';
import '../../../constants.dart';

class AnimationsBand extends StatelessWidget {
  final List<AnimationSettings> animations;
  final String heroTag;
  final int count;
  final double boxSize;
  final double separatorSize;
  final Axis direction;
  final Animation<double> animation;
  final Curve curve;
  final bool flipped;
  final void Function(String heroTag, int index)? onTap;

  const AnimationsBand({
    required this.animations,
    required this.heroTag,
    required this.count,
    required this.boxSize,
    required this.separatorSize,
    required this.direction,
    required this.animation,
    required this.curve,
    required this.flipped,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final separator = SizedBox.square(dimension: separatorSize);
    final emptyBox = SizedBox.square(dimension: boxSize);

    final widgets = List<Widget>.generate(
      count * 2 - 1,
      (index) {
        if (index.isOdd) return separator;

        final itemIndex = index ~/ 2;
        if (animations.length <= itemIndex) return emptyBox;

        final animation = animations[itemIndex];
        final itemHeroTag = '$heroTag#$itemIndex';

        return Hero(
          createRectTween: (begin, end) => RectTween(begin: begin, end: end),
          tag: itemHeroTag,
          child: SizedBox.square(
            dimension: boxSize,
            child: AnimationBox(
              animation: this.animation,
              borderRadius: boxSize * Const.borderRadiusFactor,
              curve: curve,
              flipped: flipped,
              settings: animation,
              boxColor: theme.colorScheme.primary,
              alternateColor: theme.colorScheme.secondary,
              textOnBoxColor: theme.colorScheme.onPrimary,
              textOutBoxColor: theme.colorScheme.onBackground,
              onTap: onTap == null
                  ? null
                  : () => onTap?.call(itemHeroTag, itemIndex),
            ),
          ),
        );
      },
    );

    return Flex(
      direction: direction,
      mainAxisAlignment: MainAxisAlignment.center,
      children: widgets,
    );
  }
}
