import 'package:curve_demo/ui/animation_boxes/square_circle_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'animation_boxes/color_box.dart';
import 'animation_boxes/move_box.dart';
import 'animation_boxes/opacity_box.dart';
import 'animation_boxes/rotate_box.dart';
import 'animation_boxes/scale_box.dart';
import 'animation_boxes/show_box.dart';
import 'curves/curve_painter.dart';
import 'curves/curves.dart';

const double defaultPadding = 8;

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

  late final AnimationController _animationController;
  late final Animation<double> animation;
  bool _flipped = true;
  bool _fill = true;
  late Curve _curve;
  double _a = 0.25;
  double _b = 0.1;
  double _c = 0.25;
  double _d = 1;
  double _elasticPeriod = 0.4;
  int _elasticType = 0;

  Curve get curve => _curve;
  set curve(Curve value) {
    setState(() {
      _curve = value;
      if (value is Cubic) {
        _a = value.a;
        _b = value.b;
        _c = value.c;
        _d = value.d;
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

  double get a => _a;
  set a(double value) {
    _a = value;
    _assemblyCubic();
  }

  double get b => _b;
  set b(double value) {
    _b = value;
    _assemblyCubic();
  }

  double get c => _c;
  set c(double value) {
    _c = value;
    _assemblyCubic();
  }

  double get d => _d;
  set d(double value) {
    _d = value;
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

  void _assemblyCubic() {
    curve = Cubic(a, b, c, d);
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

  Duration get animationDuration => _animationController.duration!;
  set animationDuration(Duration value) {
    setState(() {
      _animationController.duration = value;
    });
  }

  bool get flipped => _flipped;
  set flipped(bool value) {
    setState(() {
      _flipped = value;
    });
  }

  bool get fill => _fill;
  set fill(bool value) {
    setState(() {
      _fill = value;
    });
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
  Widget build(BuildContext context) => Provider.value(
        value: this,
        updateShouldNotify: (_, __) => true,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _LeftAnimatedBoxes(),
                      SizedBox(width: 2 * defaultPadding),
                      Flexible(
                        child: _Curve(),
                      ),
                      SizedBox(width: 2 * defaultPadding),
                      _RightAnimatedBoxes(),
                    ],
                  ),
                ),
              ),
              _Fill(
                fill: fill,
                onChanged: (fill) => this.fill = fill,
              ),
              _Flipped(
                flipped: flipped,
                onChanged: (flipped) => this.flipped = flipped,
              ),
              _Slider(
                label: 'duration:',
                enabled: true,
                value: _durations.indexOf(animationDuration).toDouble(),
                min: 0,
                max: _durations.length - 1,
                divisions: _durations.length,
                onChanged: (value) {
                  animationDuration = _durations[value.round()];
                },
                valueBuilder: (value) {
                  final s = animationDuration.inSeconds;
                  final ms = animationDuration.inMilliseconds % 1000;

                  return SizedBox(
                    width: 80,
                    child: Text(
                      s == 0 ? '$ms ms' : '$s s${ms == 0 ? '' : ' $ms ms'}',
                      textAlign: TextAlign.end,
                    ),
                  );
                },
              ),
              _CurveSlider(
                label: 'cubic x1:',
                enabled: curve is Cubic,
                value: a,
                onChanged: (value) => a = value,
              ),
              _CurveSlider(
                label: 'cubic y1:',
                enabled: curve is Cubic,
                value: b,
                onChanged: (value) => b = value,
              ),
              _CurveSlider(
                label: 'cubic x2:',
                enabled: curve is Cubic,
                value: c,
                onChanged: (value) => c = value,
              ),
              _CurveSlider(
                label: 'cubic y2:',
                enabled: curve is Cubic,
                value: d,
                onChanged: (value) => d = value,
              ),
              Row(
                children: [
                  Expanded(
                    child: _Slider(
                      label: 'elastic:',
                      enabled: MyCurves.isElastic(curve),
                      min: 0,
                      max: 2,
                      divisions: 3,
                      value: elasticType.toDouble(),
                      onChanged: (value) => elasticType = value.round(),
                      valueBuilder: (value) {
                        String text;
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
                          default:
                            text = '-';
                        }

                        return SizedBox(
                          width: 40,
                          child: Text(
                            text,
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: _CurveSlider(
                      enabled: MyCurves.isElastic(curve),
                      min: 0.1,
                      max: 2,
                      value: elasticPeriod,
                      onChanged: (value) => elasticPeriod = value,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: DropdownButton<String>(
                  value: MyCurves.findByCurve(curve),
                  isExpanded: true,
                  onChanged: (value) {
                    if (value != null) {
                      final curve = MyCurves.findByName(value);
                      if (curve != null) {
                        this.curve = curve;
                      }
                    }
                  },
                  items: [
                    for (final name in MyCurves.allCurves)
                      DropdownMenuItem<String>(
                        value: name,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(name),
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                curve.toString(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
}

class _Curve extends StatelessWidget {
  const _Curve();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<HomePageState>(context);

    return AspectRatio(
      aspectRatio: 1 / 1.6,
      child: CustomPaint(
        painter: CurvePainter(
          animation: state.animation,
          curve: state.curve,
          flipped: state.flipped,
          mx: 1,
          my: 1.6,
        ),
        willChange: true,
      ),
    );
  }
}

class _LeftAnimatedBoxes extends StatelessWidget {
  const _LeftAnimatedBoxes();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<HomePageState>(context);

    return SizedBox(
      width: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleBox(
            animation: state.animation,
            curve: state.curve,
            flipped: state.flipped,
            fill: state.fill,
          ),
          const SizedBox(height: defaultPadding),
          MoveBox(
            animation: state.animation,
            curve: state.curve,
            flipped: state.flipped,
            fill: state.fill,
          ),
          const SizedBox(height: defaultPadding),
          ColorBox(
            animation: state.animation,
            curve: state.curve,
            flipped: state.flipped,
            fill: state.fill,
            secondColor: const Color(0x00FFFFFF),
          ),
          const SizedBox(height: defaultPadding),
          RotateBox(
            animation: state.animation,
            curve: state.curve,
            flipped: state.flipped,
            fill: state.fill,
          ),
        ],
      ),
    );
  }
}

class _RightAnimatedBoxes extends StatelessWidget {
  const _RightAnimatedBoxes();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<HomePageState>(context);

    return SizedBox(
      width: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShowBox(
            animation: state.animation,
            curve: state.curve,
            flipped: state.flipped,
            fill: state.fill,
          ),
          const SizedBox(height: defaultPadding),
          MoveBox(
            animation: state.animation,
            curve: state.curve,
            flipped: state.flipped,
            fill: state.fill,
            axis: Axis.vertical,
          ),
          const SizedBox(height: defaultPadding),
          ColorBox(
            animation: state.animation,
            curve: state.curve,
            flipped: state.flipped,
            fill: state.fill,
            secondColor: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: defaultPadding),
          SquareCircleBox(
            animation: state.animation,
            curve: state.curve,
            flipped: state.flipped,
            fill: state.fill,
          ),
        ],
      ),
    );
  }
}

class _Fill extends StatelessWidget {
  final bool fill;
  // ignore: avoid_positional_boolean_parameters
  final void Function(bool fill) onChanged;

  const _Fill({
    required this.fill,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                'fill:',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Switch(
              value: fill,
              onChanged: onChanged,
            ),
          ],
        ),
      );
}

class _Flipped extends StatelessWidget {
  final bool flipped;
  // ignore: avoid_positional_boolean_parameters
  final void Function(bool flipped) onChanged;

  const _Flipped({
    required this.flipped,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                'flip it over when it goes back:',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Switch(
              value: flipped,
              onChanged: onChanged,
            ),
          ],
        ),
      );
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
            horizontal: defaultPadding,
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
