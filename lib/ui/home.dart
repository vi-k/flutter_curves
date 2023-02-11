import 'package:curve_demo/ui/animation_boxes/square_circle_box.dart';
import 'package:curve_demo/ui/app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'animation_boxes/color_box.dart';
import 'animation_boxes/move_box.dart';
import 'animation_boxes/rotate_box.dart';
import 'animation_boxes/scale_box.dart';
import 'animation_boxes/show_box.dart';
import 'constants.dart';
import 'curves/curve_painter.dart';
import 'curves/curves.dart';
import 'curves/simple_curve_painter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  static const Duration _defaultAnimationDuration = Duration(seconds: 1);
  static const Duration _pauseDuration = Duration(milliseconds: 500);

  late final AnimationController _animationController;
  late final Animation<double> animation;
  late Curve _curve;
  double _cubicA = 0.25;
  double _cubicB = 0.1;
  double _cubicC = 0.25;
  double _cubicD = 1;
  double _elasticPeriod = 0.4;
  int _elasticType = 0;
  bool _fill = true;
  bool _showError = true;
  bool _flipped = true;
  late Color _primaryColor;
  late Color _secondaryColor;
  late Color _errorColor;
  late Color _curveColor;
  late Color _cubicColor;

  Duration get animationDuration => _animationController.duration!;
  set animationDuration(Duration value) {
    setState(() {
      _animationController.duration = value;
    });
  }

  Curve get curve => _curve;
  set curve(Curve value) {
    setState(() {
      _curve = value;
      if (value is Cubic) {
        _cubicA = value.a;
        _cubicB = value.b;
        _cubicC = value.c;
        _cubicD = value.d;
      } else if (value is ElasticInCurve) {
        _elasticType = 0;
        _elasticPeriod = value.period;
      } else if (value is ElasticOutCurve) {
        _elasticType = 1;
        _elasticPeriod = value.period;
      } else if (value is ElasticInOutCurve) {
        _elasticType = 2;
        _elasticPeriod = value.period;
      }
    });
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

  double get elasticPeriod => _elasticPeriod;
  set elasticPeriod(double value) {
    _elasticPeriod = (value * 100).roundToDouble() / 100;
    _assemblyElastic();
  }

  int get elasticType => _elasticType;
  set elasticType(int value) {
    _elasticType = value;
    _assemblyElastic();
  }

  bool get fill => _fill;
  set fill(bool value) {
    setState(() {
      _fill = value;
    });
  }

  bool get showError => _showError;
  set showError(bool value) {
    setState(() {
      _showError = value;
    });
  }

  bool get flipped => _flipped;
  set flipped(bool value) {
    setState(() {
      _flipped = value;
    });
  }

  Color get primaryColor => _primaryColor;
  Color get secondaryColor => _secondaryColor;
  Color get errorColor => _errorColor;
  Color get curveColor => _curveColor;
  Color get cubicColor => _cubicColor;

  void _assemblyCubic() {
    curve = Cubic(cubicA, cubicB, cubicC, cubicD);
  }

  void _assemblyElastic() {
    switch (_elasticType) {
      case 0:
        curve = ElasticInCurve(_elasticPeriod);
        break;
      case 1:
        curve = ElasticOutCurve(_elasticPeriod);
        break;
      case 2:
        curve = ElasticInOutCurve(_elasticPeriod);
        break;
    }
  }

  @override
  void initState() {
    super.initState();

    curve = Curves.ease;

    _animationController = AnimationController(
      duration: _defaultAnimationDuration,
      vsync: this,
    );

    animation = TweenSequence(
      [
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 0,
            end: 1,
          ),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: -1,
            end: 0,
          ),
          weight: 1,
        ),
      ],
    ).animate(_animationController);

    _animationLoop();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    final theme = Theme.of(context);

    _primaryColor = theme.colorScheme.primary;
    _secondaryColor = theme.colorScheme.secondary;
    _errorColor = theme.colorScheme.error;
    _curveColor =
        theme.brightness == Brightness.light ? Colors.red : Colors.red.shade700;
    _cubicColor = (theme.brightness == Brightness.light
            ? Colors.blue
            : Colors.blue.shade700)
        .withOpacity(0.7);

    super.didChangeDependencies();
  }

  Future<void> _animationLoop() async {
    while (mounted) {
      await Future<void>.delayed(_pauseDuration);
      if (!mounted) break;
      await _animationController.animateTo(0.5);
      if (!mounted) break;
      await Future<void>.delayed(_pauseDuration);
      if (!mounted) break;
      await _animationController.animateTo(1);
      _animationController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Provider.value(
      value: this,
      updateShouldNotify: (_, __) => true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: const [
            _ThemeSwitcher(),
          ],
        ),
        body: Column(
          children: [
            const Expanded(
              flex: 2,
              child: _Main(),
            ),
            const _CurveInfo(),
            Expanded(
              flex: 3,
              child: ListView(
                children: const [
                  _CurvesSelector(),
                  _Fill(),
                  _Flipped(),
                  _ShowError(),
                  _Duration(),
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
    final appState = Provider.of<AppState>(context);

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

class _Curve extends StatelessWidget {
  const _Curve();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<HomePageState>(context);
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: AspectRatio(
        aspectRatio: 1 / 1.6,
        child: CustomPaint(
          painter: CurvePainter(
            animation: state.animation,
            curve: state.curve,
            flipped: state.flipped,
            mx: 1,
            my: 1.6,
            curveColor: state.curveColor,
            valueColor: state.curveColor,
            axisColor: theme.colorScheme.inverseSurface.withOpacity(0.7),
            gridPrimaryColor: theme.colorScheme.inverseSurface.withOpacity(0.2),
            gridSecondaryColor:
                theme.colorScheme.inverseSurface.withOpacity(0.1),
            cubicMarkerColor: state.cubicColor,
            cubicLineColor: state.cubicColor,
          ),
        ),
      ),
    );
  }
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

class _BoxesHeightDivider extends SizedBox {
  const _BoxesHeightDivider() : super(height: 2 * Const.defaultPadding);
}

class _LeftAnimatedBoxes extends StatelessWidget {
  const _LeftAnimatedBoxes();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<HomePageState>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: ScaleBox(
            animation: state.animation,
            curve: state.curve,
            fill: state.fill,
            flipped: state.flipped,
            primaryColor: state.primaryColor,
            showError: state.showError,
            errorColor: state.errorColor,
          ),
        ),
        const _BoxesHeightDivider(),
        Expanded(
          child: MoveBox(
            animation: state.animation,
            curve: state.curve,
            fill: state.fill,
            flipped: state.flipped,
            primaryColor: state.primaryColor,
          ),
        ),
        const _BoxesHeightDivider(),
        Expanded(
          child: ColorBox(
            animation: state.animation,
            curve: state.curve,
            fill: state.fill,
            flipped: state.flipped,
            primaryColor: state.primaryColor,
            secondaryColor: Colors.transparent,
            showError: state.showError,
            errorColor: state.errorColor,
          ),
        ),
        const _BoxesHeightDivider(),
        Expanded(
          child: RotateBox(
            animation: state.animation,
            curve: state.curve,
            fill: state.fill,
            flipped: state.flipped,
            primaryColor: state.primaryColor,
          ),
        ),
      ],
    );
  }
}

class _RightAnimatedBoxes extends StatelessWidget {
  const _RightAnimatedBoxes();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = Provider.of<HomePageState>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ShowBox(
            animation: state.animation,
            curve: state.curve,
            fill: state.fill,
            flipped: state.flipped,
            primaryColor: state.primaryColor,
            showError: state.showError,
            errorColor: state.errorColor,
          ),
        ),
        const _BoxesHeightDivider(),
        Expanded(
          child: MoveBox(
            animation: state.animation,
            curve: state.curve,
            fill: state.fill,
            flipped: state.flipped,
            primaryColor: state.primaryColor,
            axis: Axis.vertical,
          ),
        ),
        const _BoxesHeightDivider(),
        Expanded(
          child: ColorBox(
            animation: state.animation,
            curve: state.curve,
            fill: state.fill,
            flipped: state.flipped,
            primaryColor: state.primaryColor,
            secondaryColor: theme.colorScheme.secondary,
            showError: state.showError,
            errorColor: state.errorColor,
          ),
        ),
        const _BoxesHeightDivider(),
        Expanded(
          child: SquareCircleBox(
            animation: state.animation,
            curve: state.curve,
            fill: state.fill,
            flipped: state.flipped,
            primaryColor: state.primaryColor,
            showError: state.showError,
            errorColor: state.errorColor,
          ),
        ),
      ],
    );
  }
}

class _Main extends StatelessWidget {
  const _Main();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.all(Const.defaultPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: _LeftAnimatedBoxes()),
            SizedBox(width: 2 * Const.defaultPadding),
            Flexible(flex: 4, child: _Curve()),
            SizedBox(width: 2 * Const.defaultPadding),
            Flexible(child: _RightAnimatedBoxes()),
          ],
        ),
      );
}

class _CurveInfo extends StatelessWidget {
  const _CurveInfo();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<HomePageState>(context);

    return Text(
      state.curve.toString(),
      textAlign: TextAlign.center,
    );
  }
}

class _Fill extends StatelessWidget {
  const _Fill();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<HomePageState>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Const.defaultPadding,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Fill:',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Switch(
            value: state.fill,
            onChanged: (value) => state.fill = value,
          ),
        ],
      ),
    );
  }
}

class _Flipped extends StatelessWidget {
  const _Flipped();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<HomePageState>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Const.defaultPadding,
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
            value: state.flipped,
            onChanged: (value) => state.flipped = value,
          ),
        ],
      ),
    );
  }
}

class _ShowError extends StatelessWidget {
  const _ShowError();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<HomePageState>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Const.defaultPadding,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Show error:',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Switch(
            value: state.showError,
            onChanged: (value) => state.showError = value,
          ),
        ],
      ),
    );
  }
}

class _Duration extends StatelessWidget {
  static const List<Duration> _durations = [
    Duration(milliseconds: 100),
    Duration(milliseconds: 200),
    Duration(milliseconds: 300),
    Duration(milliseconds: 500),
    Duration(seconds: 1),
    Duration(seconds: 2),
    Duration(seconds: 5),
    Duration(seconds: 10),
    Duration(seconds: 20),
  ];

  const _Duration();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<HomePageState>(context);

    return _Slider(
      label: 'Duration:',
      enabled: true,
      value: _durations.indexOf(state.animationDuration).toDouble(),
      min: 0,
      max: _durations.length - 1,
      divisions: _durations.length,
      onChanged: (value) {
        state.animationDuration = _durations[value.round()];
      },
      valueBuilder: (value) {
        final s = state.animationDuration.inSeconds;
        final ms = state.animationDuration.inMilliseconds % 1000;

        return SizedBox(
          width: 80,
          child: Text(
            s == 0 ? '$ms ms' : '$s s${ms == 0 ? '' : ' $ms ms'}',
            textAlign: TextAlign.end,
          ),
        );
      },
    );
  }
}

class _Cubic extends StatelessWidget {
  const _Cubic();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<HomePageState>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CurveSlider(
          label: 'Cubic x1:',
          enabled: state.curve is Cubic,
          value: state.cubicA,
          onChanged: (value) => state.cubicA = value,
        ),
        _CurveSlider(
          label: 'Cubic y1:',
          enabled: state.curve is Cubic,
          value: state.cubicB,
          onChanged: (value) => state.cubicB = value,
        ),
        _CurveSlider(
          label: 'Cubic x2:',
          enabled: state.curve is Cubic,
          value: state.cubicC,
          onChanged: (value) => state.cubicC = value,
        ),
        _CurveSlider(
          label: 'Cubic y2:',
          enabled: state.curve is Cubic,
          value: state.cubicD,
          onChanged: (value) => state.cubicD = value,
        )
      ],
    );
  }
}

class _Elastic extends StatelessWidget {
  const _Elastic();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<HomePageState>(context);

    return Row(
      children: [
        Expanded(
          child: _Slider(
            label: 'Elastic:',
            enabled: MyCurves.isElastic(state.curve),
            min: 0,
            max: 2,
            divisions: 3,
            value: state.elasticType.toDouble(),
            onChanged: (value) => state.elasticType = value.round(),
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
            enabled: MyCurves.isElastic(state.curve),
            min: 0.1,
            max: 2,
            value: state.elasticPeriod,
            onChanged: (value) => state.elasticPeriod = value,
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
    final state = Provider.of<HomePageState>(context);

    return DropdownButton<String>(
      value: MyCurves.findByCurve(state.curve),
      isExpanded: true,
      menuMaxHeight: 400,
      onChanged: (value) {
        if (value != null) {
          final curve = MyCurves.findByName(value);
          if (curve != null) {
            state.curve = curve;
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
                    curveColor: state.curveColor,
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
    super.min = -0.5,
    super.max = 1.5,
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
