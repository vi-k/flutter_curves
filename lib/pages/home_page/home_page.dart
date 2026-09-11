import 'dart:async';
import 'dart:math' as math;

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:scopo/scopo.dart';

import '../../app.dart';
import '../../common/dialog_for_page_route.dart';
import '../../constants.dart';
import '../../curves/export.dart';
import '../../curves/widgets/curve_box.dart';
import '../../motions/export.dart';
import '../motions_page/motions_dialog.dart';
import 'widgets/duration_select.dart';
import 'widgets/motions_band.dart';

const IList<Duration> _durations = IListConst([
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
]);

const IList<Duration> _pauses = IListConst([
  Duration.zero,
  Duration(milliseconds: 100),
  Duration(milliseconds: 200),
  Duration(milliseconds: 300),
  Duration(milliseconds: 500),
  Duration(seconds: 1),
  Duration(seconds: 2),
  Duration(seconds: 3),
  Duration(seconds: 5),
]);

/// The ticker owner of the home screen.
///
/// A scope state cannot be one: `scopo` seals its `dispose` and refuses
/// `State.widget`, which is what `SingleTickerProviderStateMixin` reaches for.
/// So the [MotionController] is created, driven and released here, and handed
/// to [HomeScope] as a parameter. Owning it here also fixes the teardown
/// order: the scope's subtree unmounts before this state, so nothing is still
/// painting by the time the ticker stops.
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final MotionController _motionController;

  @override
  void initState() {
    super.initState();

    _motionController = MotionController(vsync: this);
    unawaited(_motionController.start());
  }

  @override
  void dispose() {
    _motionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      HomeScope(title: widget.title, motionController: _motionController);
}

/// The scope of the home screen.
final class HomeScope extends LiteScope<HomeScope, HomeScopeState> {
  const HomeScope({
    super.key,
    required this.title,
    required this.motionController,
  });

  final String title;
  final MotionController motionController;

  /// The type arguments of this scope, named once.
  static const access = LiteScopeAccess<HomeScope, HomeScopeState>();

  @override
  Widget? buildOnWaiting(BuildContext context) => const SizedBox.shrink();

  @override
  HomeScopeState createState() => HomeScopeState();
}

/// The state of the home screen: the curve under study and everything the
/// controls set on it.
final class HomeScopeState extends LiteScopeState<HomeScope, HomeScopeState> {
  static const double _initialElasticPeriod = 0.4;
  static const int _initialElasticType = 0;
  static const bool _initialFlipped = true;

  late Curve _curve;
  late double _cubicA;
  late double _cubicB;
  late double _cubicC;
  late double _cubicD;
  int _elasticType = _initialElasticType;
  double _elasticPeriod = _initialElasticPeriod;
  bool _flipped = _initialFlipped;

  late Color _boxColor;
  late Color _alternateColor;
  late Color _textOnBoxColor;
  late Color _textOutBoxColor;

  IList<MotionObject> _firstMotions = defaultFirstMotions;
  IList<MotionObject> _secondMotions = defaultSecondMotions;

  /// The one controller driving every motion and the graph on this screen.
  MotionController get motionController => params.motionController;

  Curve get curve => _curve;
  set curve(Curve value) {
    _applyCurve(value);
    notifyDependents();
  }

  double get cubicA => _cubicA;
  set cubicA(double value) {
    _cubicA = value;
    _assemblyCubic();
  }

  double get cubicB => _cubicB;
  set cubicB(double value) {
    _cubicB = value;
    _assemblyCubic();
  }

  double get cubicC => _cubicC;
  set cubicC(double value) {
    _cubicC = value;
    _assemblyCubic();
  }

  double get cubicD => _cubicD;
  set cubicD(double value) {
    _cubicD = value;
    _assemblyCubic();
  }

  int get elasticType => _elasticType;
  set elasticType(int value) {
    _elasticType = value;
    _assemblyElastic();
  }

  double get elasticPeriod => _elasticPeriod;
  set elasticPeriod(double value) {
    _elasticPeriod = (value * 100).roundToDouble() / 100;
    _assemblyElastic();
  }

  bool get flipped => _flipped;
  set flipped(bool value) {
    _flipped = value;
    notifyDependents();
  }

  Color get boxColor => _boxColor;
  Color get alternateColor => _alternateColor;
  Color get textOnBoxColor => _textOnBoxColor;
  Color get textOutBoxColor => _textOutBoxColor;

  IList<MotionObject> get firstMotions => _firstMotions;
  IList<MotionObject> get secondMotions => _secondMotions;

  @override
  void initState() {
    super.initState();

    // Through the same path a later change takes, so the sliders start out
    // agreeing with the curve instead of repeating its coefficients here.
    _applyCurve(Curves.ease);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final theme = Theme.of(context);

    _boxColor = theme.colorScheme.primary;
    _alternateColor = theme.colorScheme.secondary;
    _textOnBoxColor = theme.colorScheme.onPrimary;
    _textOutBoxColor = theme.colorScheme.onSurface;
  }

  /// Takes the curve apart into the values the sliders show.
  void _applyCurve(Curve value) {
    _curve = value;

    switch (value) {
      case final Cubic curve:
        _cubicA = curve.a;
        _cubicB = curve.b;
        _cubicC = curve.c;
        _cubicD = curve.d;
      case final ElasticInCurve curve:
        _elasticType = 0;
        _elasticPeriod = curve.period;
      case final ElasticOutCurve curve:
        _elasticType = 1;
        _elasticPeriod = curve.period;
      case final ElasticInOutCurve curve:
        _elasticType = 2;
        _elasticPeriod = curve.period;
    }
  }

  void _assemblyCubic() {
    curve = Cubic(cubicA, cubicB, cubicC, cubicD);
  }

  void _assemblyElastic() {
    curve = switch (_elasticType) {
      0 => ElasticInCurve(_elasticPeriod),
      1 => ElasticOutCurve(_elasticPeriod),
      _ => ElasticInOutCurve(_elasticPeriod),
    };
  }

  void selectFirstMotion(String heroTag, int index) =>
      unawaited(_selectMotion(heroTag, index, first: true));

  void selectSecondMotion(String heroTag, int index) =>
      unawaited(_selectMotion(heroTag, index, first: false));

  Future<void> _selectMotion(
    String heroTag,
    int index, {
    required bool first,
  }) async {
    final newMotion = await Navigator.of(context).push<MotionObject>(
      DialogForPageRoute(
        barrierDismissible: true,
        builder: (_) => MotionsDialog(
          parent: this,
          animation: motionController.animation,
          selectedMotion: (first ? firstMotions : secondMotions)[index],
          selectedHeroTag: heroTag,
        ),
      ),
    );

    if (newMotion == null) return;

    if (first) {
      _firstMotions = _firstMotions.put(index, newMotion);
    } else {
      _secondMotions = _secondMotions.put(index, newMotion);
    }
    notifyDependents();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Text(params.title),
        actions: const [_ThemeSwitcher()],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) =>
            constraints.maxWidth > constraints.maxHeight
            ? Row(
                children: [
                  const Expanded(
                    child: Column(
                      children: [
                        Expanded(child: _Main()),
                        _CurveInfo(),
                      ],
                    ),
                  ),
                  const VerticalDivider(width: 1),
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

class _Main extends StatelessWidget {
  const _Main();

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
              Const.curveHorisontalMultiplier;
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
    horisontalMultiplier: Const.curveHorisontalMultiplier,
    verticalMultiplier: Const.curveVerticalMultiplier,
  );
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

class _CurveInfo extends StatelessWidget {
  const _CurveInfo();

  @override
  Widget build(BuildContext context) => Text(
    describeCurve(HomeScope.access.select(context, (state) => state.curve)),
    textAlign: TextAlign.center,
  );
}

class _Flipped extends StatelessWidget {
  const _Flipped();

  @override
  Widget build(BuildContext context) => Padding(
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
          value: HomeScope.access.select(context, (state) => state.flipped),
          onChanged: (value) => HomeScope.access.of(context).flipped = value,
        ),
      ],
    ),
  );
}

class _Duration extends StatelessWidget {
  const _Duration();

  @override
  Widget build(BuildContext context) {
    final motionController = HomeScope.access.of(context).motionController;

    return ListenableBuilder(
      listenable: motionController,
      builder: (context, child) => Padding(
        padding: const EdgeInsets.only(top: Const.defaultPadding),
        child: DurationSelect(
          label: const Text('Duration:'),
          value: motionController.animationDuration,
          durations: _durations,
          onChanged: (value) => motionController.animationDuration = value,
        ),
      ),
    );
  }
}

class _Pause extends StatelessWidget {
  const _Pause();

  @override
  Widget build(BuildContext context) {
    final motionController = HomeScope.access.of(context).motionController;

    return ListenableBuilder(
      listenable: motionController,
      builder: (context, child) => Padding(
        padding: const EdgeInsets.only(top: Const.defaultPadding),
        child: DurationSelect(
          label: const Text('Pause:'),
          value: motionController.pauseDuration,
          durations: _pauses,
          onChanged: (value) => motionController.pauseDuration = value,
        ),
      ),
    );
  }
}

class _Cubic extends StatelessWidget {
  const _Cubic();

  @override
  Widget build(BuildContext context) {
    final scope = HomeScope.access.of(context);
    final enabled = HomeScope.access.select(
      context,
      (state) => state.curve is Cubic,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CurveSlider(
          label: 'Cubic x1:',
          enabled: enabled,
          value: HomeScope.access.select(context, (state) => state.cubicA),
          onChanged: (value) => scope.cubicA = value,
        ),
        _CurveSlider(
          label: 'Cubic y1:',
          enabled: enabled,
          value: HomeScope.access.select(context, (state) => state.cubicB),
          onChanged: (value) => scope.cubicB = value,
        ),
        _CurveSlider(
          label: 'Cubic x2:',
          enabled: enabled,
          value: HomeScope.access.select(context, (state) => state.cubicC),
          onChanged: (value) => scope.cubicC = value,
        ),
        _CurveSlider(
          label: 'Cubic y2:',
          enabled: enabled,
          value: HomeScope.access.select(context, (state) => state.cubicD),
          onChanged: (value) => scope.cubicD = value,
        ),
      ],
    );
  }
}

class _Elastic extends StatelessWidget {
  const _Elastic();

  @override
  Widget build(BuildContext context) {
    final scope = HomeScope.access.of(context);
    final enabled = HomeScope.access.select(
      context,
      (state) => isElasticCurve(state.curve),
    );

    return Row(
      children: [
        Expanded(
          child: _Slider(
            label: 'Elastic:',
            enabled: enabled,
            min: 0,
            max: 2,
            divisions: 3,
            value: HomeScope.access
                .select(context, (state) => state.elasticType)
                .toDouble(),
            onChanged: (value) => scope.elasticType = value.round(),
            valueBuilder: (value) => SizedBox(
              width: 30,
              child: Text(switch (value.round()) {
                0 => 'in',
                1 => 'out',
                2 => 'in out',
                _ => '',
              }, textAlign: TextAlign.center),
            ),
          ),
        ),
        Expanded(
          child: _CurveSlider(
            enabled: enabled,
            min: 0.1,
            max: 2,
            value: HomeScope.access.select(
              context,
              (state) => state.elasticPeriod,
            ),
            onChanged: (value) => scope.elasticPeriod = value,
          ),
        ),
      ],
    );
  }
}

class _CurvesSelector extends StatelessWidget {
  const _CurvesSelector();

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

class _Slider extends StatelessWidget {
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

  final String? label;
  final bool enabled;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final void Function(double value) onChanged;
  final Widget Function(double value)? valueBuilder;

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
           child: Text(value.toStringAsFixed(2), textAlign: TextAlign.end),
         ),
       );
}
