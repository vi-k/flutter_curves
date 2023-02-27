import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_scope/flutter_scope.dart';

import '../../app.dart';
import '../../constants.dart';
import '../../curves/export.dart';
import '../../curves/widgets/curve_box.dart';
import 'home_page_controller.dart';
import 'widgets/animations_band.dart';
import 'widgets/duration_select.dart';

const List<Duration> _durations = [
  Duration(milliseconds: 100),
  Duration(milliseconds: 200),
  Duration(milliseconds: 300),
  Duration(milliseconds: 500),
  Duration(seconds: 1),
  Duration(seconds: 2),
  Duration(seconds: 3),
  Duration(seconds: 5),
  Duration(seconds: 10),
  Duration(seconds: 20),
  Duration(seconds: 30),
];

const List<Duration> _pauses = [
  Duration.zero,
  Duration(milliseconds: 100),
  Duration(milliseconds: 200),
  Duration(milliseconds: 300),
  Duration(milliseconds: 500),
  Duration(seconds: 1),
  Duration(seconds: 2),
  Duration(seconds: 3),
  Duration(seconds: 5),
];

class HomePage extends ScopeRoot<HomePageController>
    with ScopeSingleTickerProviderMixin {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  HomePageController createScope() => HomePageController();

  @override
  Widget build(BuildContext context, HomePageController scope) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Text(title),
        actions: const [
          _ThemeSwitcher(),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) =>
            constraints.maxWidth > constraints.maxHeight
                ? Row(
                    children: [
                      Expanded(
                        flex: constraints.maxWidth.round(),
                        child: const Column(
                          children: [
                            Expanded(
                              child: _Main(),
                            ),
                            _CurveInfo(),
                          ],
                        ),
                      ),
                      const VerticalDivider(
                        width: 1,
                      ),
                      Expanded(
                        flex: constraints.maxHeight.round(),
                        child: ListView(
                          children: const [
                            _CurvesSelector(),
                            _Duration(),
                            _Pause(),
                            _Flipped(),
                            _Cubic(),
                            _Elastic(),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _Main(),
                      const _CurveInfo(),
                      const Divider(),
                      Expanded(
                        child: ListView(
                          children: const [
                            _CurvesSelector(),
                            _Duration(),
                            _Pause(),
                            _Flipped(),
                            _Cubic(),
                            _Elastic(),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

class _ThemeSwitcher extends StatelessWidget {
  const _ThemeSwitcher();

  @override
  Widget build(BuildContext context) {
    final appState = Scope.watch<AppState>(context);

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
        children: [
          if (current != null) current,
          ...previous,
        ],
      ),
      child: appState.brightness == Brightness.light
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

class _Main extends ScopeWidget<HomePageController> {
  const _Main();

  @override
  Widget build(BuildContext context, HomePageController scope) => Padding(
        padding: const EdgeInsets.all(Const.defaultPadding),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final firstAnimations = scope.firstAnimations;
            final secondAnimations = scope.secondAnimations;
            final count = math.max(
              firstAnimations.length,
              secondAnimations.length,
            );

            final curveM = count + (count - 1) * Const.separatorFactor;
            final size = (firstAnimations.isEmpty ? 0 : 1) +
                Const.separatorFactor * 2 +
                curveM +
                Const.separatorFactor * 2 +
                (secondAnimations.isEmpty ? 0 : 1);

            late Axis direction;
            late double boxSize;

            if (constraints.maxWidth.isFinite) {
              boxSize = constraints.maxWidth / size;
              direction = Axis.horizontal;
            }

            if (constraints.maxHeight.isFinite) {
              final vBoxSize = constraints.maxHeight / size;
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

            final separatorSize = boxSize / 10;
            final curveHeight = curveM * boxSize;
            final curveWidth = curveHeight /
                Const.curveVerticalMultiplier *
                Const.curveHorisontalMultiplier;
            final separator = SizedBox.square(dimension: 2 * separatorSize);

            return Flex(
              direction: direction,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimationsBand(
                  animations: firstAnimations,
                  heroTag: 'first-animations',
                  count: count,
                  boxSize: boxSize,
                  separatorSize: separatorSize,
                  direction: direction == Axis.horizontal
                      ? Axis.vertical
                      : Axis.horizontal,
                  animation: scope.controllerForAnimations.animation,
                  curve: scope.curve,
                  flipped: scope.flipped,
                  onTap: (heroTag, index) => scope.selectAnimation(
                    firstAnimations,
                    heroTag,
                    index,
                  ),
                ),
                separator,
                SizedBox(
                  width: curveWidth,
                  height: curveHeight,
                  child: const _Curve(),
                ),
                separator,
                AnimationsBand(
                  animations: secondAnimations,
                  heroTag: 'second-animations',
                  count: count,
                  boxSize: boxSize,
                  separatorSize: separatorSize,
                  direction: direction == Axis.horizontal
                      ? Axis.vertical
                      : Axis.horizontal,
                  animation: scope.controllerForAnimations.animation,
                  curve: scope.curve,
                  flipped: scope.flipped,
                  onTap: (heroTag, index) => scope.selectAnimation(
                    secondAnimations,
                    heroTag,
                    index,
                  ),
                ),
              ].reversed.toList(),
            );
          },
        ),
      );
}

class _Curve extends ScopeWidget<HomePageController> {
  const _Curve();

  @override
  Widget build(BuildContext context, HomePageController scope) => CurveBox(
        animation: scope.controllerForAnimations.animation,
        curve: scope.curve,
        flipped: scope.flipped,
        horisontalMultiplier: Const.curveHorisontalMultiplier,
        verticalMultiplier: Const.curveVerticalMultiplier,
      );
}

class _SimpleCurve extends StatelessWidget {
  final Curve curve;
  final Color curveColor;

  const _SimpleCurve({
    required this.curve,
    required this.curveColor,
  });

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
            axisColor: theme.colorScheme.inverseSurface.withOpacity(0.5),
            gridColor: theme.colorScheme.inverseSurface.withOpacity(0.2),
          ),
        ),
      ),
    );
  }
}

class _CurveInfo extends ScopeWidget<HomePageController> {
  const _CurveInfo();

  @override
  Widget build(BuildContext context, HomePageController scope) => Text(
        scope.curve.toString(),
        textAlign: TextAlign.center,
      );
}

class _Flipped extends ScopeWidget<HomePageController> {
  const _Flipped();

  @override
  Widget build(BuildContext context, HomePageController scope) => Padding(
        padding: const EdgeInsets.only(
          top: Const.defaultPadding,
          left: Const.defaultPadding,
          right: Const.defaultPadding,
        ),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                'Flip it over when it goes back:',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Switch(
              value: scope.flipped,
              onChanged: (value) => scope.flipped = value,
            ),
          ],
        ),
      );
}

class _Duration extends ScopeWidget<HomePageController> {
  const _Duration();

  @override
  Widget build(BuildContext context, HomePageController scope) =>
      AnimatedBuilder(
        animation: scope.controllerForAnimations,
        builder: (context, child) => Padding(
          padding: const EdgeInsets.only(
            top: Const.defaultPadding,
          ),
          child: DurationSelect(
            label: const Text('Duration:'),
            value: scope.controllerForAnimations.animationDuration,
            durations: _durations,
            onChanged: (value) {
              scope.controllerForAnimations.animationDuration = value;
            },
          ),
        ),
      );
}

class _Pause extends ScopeWidget<HomePageController> {
  const _Pause();

  @override
  Widget build(BuildContext context, HomePageController scope) =>
      AnimatedBuilder(
        animation: scope.controllerForAnimations,
        builder: (context, child) => Padding(
          padding: const EdgeInsets.only(
            top: Const.defaultPadding,
          ),
          child: DurationSelect(
            label: const Text('Pause:'),
            value: scope.controllerForAnimations.pauseDuration,
            durations: _pauses,
            onChanged: (value) {
              scope.controllerForAnimations.pauseDuration = value;
            },
          ),
        ),
      );
}

class _Cubic extends ScopeWidget<HomePageController> {
  const _Cubic();

  @override
  Widget build(BuildContext context, HomePageController scope) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CurveSlider(
            label: 'Cubic x1:',
            enabled: scope.curve is Cubic,
            value: scope.cubicA,
            onChanged: (value) => scope.cubicA = value,
          ),
          _CurveSlider(
            label: 'Cubic y1:',
            enabled: scope.curve is Cubic,
            value: scope.cubicB,
            onChanged: (value) => scope.cubicB = value,
          ),
          _CurveSlider(
            label: 'Cubic x2:',
            enabled: scope.curve is Cubic,
            value: scope.cubicC,
            onChanged: (value) => scope.cubicC = value,
          ),
          _CurveSlider(
            label: 'Cubic y2:',
            enabled: scope.curve is Cubic,
            value: scope.cubicD,
            onChanged: (value) => scope.cubicD = value,
          )
        ],
      );
}

class _Elastic extends ScopeWidget<HomePageController> {
  const _Elastic();

  @override
  Widget build(BuildContext context, HomePageController scope) => Row(
        children: [
          Expanded(
            child: _Slider(
              label: 'Elastic:',
              enabled: MyCurves.isElastic(scope.curve),
              min: 0,
              max: 2,
              divisions: 3,
              value: scope.elasticType.toDouble(),
              onChanged: (value) => scope.elasticType = value.round(),
              valueBuilder: (value) {
                var text = '';
                switch (value.round()) {
                  case 0:
                    text = 'in';
                    break;
                  case 1:
                    text = 'out';
                    break;
                  case 2:
                    text = 'in out';
                    break;
                }

                return SizedBox(
                  width: 30,
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: _CurveSlider(
              enabled: MyCurves.isElastic(scope.curve),
              min: 0.1,
              max: 2,
              value: scope.elasticPeriod,
              onChanged: (value) => scope.elasticPeriod = value,
            ),
          ),
        ],
      );
}

class _CurvesSelector extends ScopeWidget<HomePageController> {
  const _CurvesSelector();

  @override
  Widget build(BuildContext context, HomePageController scope) {
    final theme = Theme.of(context);

    return DropdownButton<String>(
      value: MyCurves.findByCurve(scope.curve),
      isExpanded: true,
      menuMaxHeight: 400,
      onChanged: (value) {
        if (value != null) {
          final curve = MyCurves.findByName(value);
          if (curve != null) {
            scope.curve = curve;
          }
        }
      },
      items: [
        for (final name in MyCurves.allCurves)
          DropdownMenuItem<String>(
            value: name,
            child: Padding(
              padding: const EdgeInsets.all(Const.defaultPadding),
              child: Row(
                children: [
                  Expanded(
                    child: Text(name),
                  ),
                  _SimpleCurve(
                    curve: MyCurves.findByName(name)!,
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

class _Slider extends StatelessWidget {
  final String? label;
  final bool enabled;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final void Function(double value) onChanged;
  final Widget Function(double value)? valueBuilder;

  const _Slider({
    this.label,
    required this.enabled,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    required this.onChanged,
    this.valueBuilder,
  });

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: enabled ? 1 : 0.5,
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: Const.defaultPadding,
          ),
          child: Row(
            children: [
              if (label != null) Text(label!),
              Expanded(
                child: Slider.adaptive(
                  value: value,
                  min: min,
                  max: max,
                  divisions: divisions,
                  onChanged: onChanged,
                ),
              ),
              if (valueBuilder != null) valueBuilder!(value),
            ],
          ),
        ),
      );
}

class _CurveSlider extends _Slider {
  _CurveSlider({
    super.label,
    required super.value,
    super.min = -0.6,
    super.max = 1.6,
    required super.onChanged,
    required super.enabled,
  }) : super(
          divisions: ((max - min) * 100).round(),
          valueBuilder: (value) => SizedBox(
            width: 40,
            child: Text(
              value.toStringAsFixed(2),
              textAlign: TextAlign.end,
            ),
          ),
        );
}
