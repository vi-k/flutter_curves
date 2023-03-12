import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../motions/export.dart';

class MotionsBand extends StatelessWidget {
  const MotionsBand({
    super.key,
    required this.motions,
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

  final IList<MotionObject> motions;
  final String heroTag;
  final int count;
  final double boxSize;
  final double separatorSize;
  final Axis direction;
  final Animation<double> animation;
  final Curve curve;
  final bool flipped;
  final void Function(String heroTag, int index)? onTap;

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
        if (motions.length <= itemIndex) return emptyBox;

        final motion = motions[itemIndex];
        final itemHeroTag = '$heroTag#$itemIndex';

        return Hero(
          createRectTween: (begin, end) => RectTween(begin: begin, end: end),
          tag: itemHeroTag,
          child: SizedBox.square(
            dimension: boxSize,
            child: Motion(
              motion: motion,
              animation: animation,
              borderRadius: boxSize * Const.borderRadiusFactor,
              curve: curve,
              flipped: flipped,
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
