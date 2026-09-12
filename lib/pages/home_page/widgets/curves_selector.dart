import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../curves/export.dart';
import '../home_scope.dart';

class CurvesSelector extends StatelessWidget {
  const CurvesSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final curve = HomeScope.access.select(context, (state) => state.curve);

    return DropdownButton<String>(
      value: findNameByCurve(curve),
      isExpanded: true,
      menuMaxHeight: 400,
      onChanged: (value) {
        if (value == null) return;

        final newCurve = findCurveByName(value);
        if (newCurve != null) {
          HomeScope.access.of(context).curve = newCurve;
        }
      },
      items: [
        for (final name in curvesTemplates)
          DropdownMenuItem<String>(
            value: name,
            child: Padding(
              padding: const EdgeInsets.all(Const.defaultPadding),
              child: Row(
                children: [
                  Expanded(child: Text(name)),
                  _SimpleCurve(
                    curve: findCurveByName(name)!,
                    curveColor: theme.colorScheme.secondary,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _SimpleCurve extends StatelessWidget {
  const _SimpleCurve({required this.curve, required this.curveColor});

  final Curve curve;
  final Color curveColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: CustomPaint(
          painter: SimpleCurvePainter(
            curve: curve,
            mx: 1,
            my: 1,
            curveColor: curveColor,
            axisColor: theme.colorScheme.inverseSurface.withValues(alpha: 0.5),
            gridColor: theme.colorScheme.inverseSurface.withValues(alpha: 0.2),
          ),
        ),
      ),
    );
  }
}
