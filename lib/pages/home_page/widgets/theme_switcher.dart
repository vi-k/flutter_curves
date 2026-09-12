import 'package:flutter/material.dart';

import '../../../app.dart';
import '../../../constants.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = App.access.of(context);

    return AnimatedSwitcher(
      duration: Const.defaultAnimationDuration,
      switchInCurve: Curves.easeInSine,
      switchOutCurve: Curves.easeOutSine,
      transitionBuilder: (child, animation) => SizeTransition(
        key: child.key,
        axis: Axis.horizontal,
        sizeFactor: animation,
        child: child,
      ),
      layoutBuilder: (current, previous) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [if (current != null) current, ...previous],
      ),
      child: theme.brightness == Brightness.light
          ? IconButton(
              key: const ValueKey('night'),
              onPressed: () => appState.brightness = Brightness.dark,
              icon: const Icon(Icons.mode_night),
            )
          : IconButton(
              key: const ValueKey('day'),
              onPressed: () => appState.brightness = Brightness.light,
              icon: const Icon(Icons.light_mode),
            ),
    );
  }
}
