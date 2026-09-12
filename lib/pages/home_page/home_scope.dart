import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:scopo/scopo.dart';

import '../../common/dialog_for_page_route.dart';
import '../../motions/export.dart';
import '../motions_page/motions_dialog.dart';
import 'widgets/curve_info.dart';
import 'widgets/curve_sliders.dart';
import 'widgets/curves_selector.dart';
import 'widgets/duration_controls.dart';
import 'widgets/flipped_switch.dart';
import 'widgets/home_content.dart';
import 'widgets/theme_switcher.dart';

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
        actions: const [ThemeSwitcher()],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) =>
            constraints.maxWidth > constraints.maxHeight
            ? Row(
                children: [
                  const Expanded(
                    child: Column(
                      children: [
                        Expanded(child: HomeContent()),
                        CurveInfo(),
                      ],
                    ),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(
                    child: ListView(
                      children: const [
                        CurvesSelector(),
                        DurationControl(),
                        PauseControl(),
                        FlippedSwitch(),
                        CubicControls(),
                        ElasticControls(),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const HomeContent(),
                  const CurveInfo(),
                  const Divider(),
                  Expanded(
                    child: ListView(
                      children: const [
                        CurvesSelector(),
                        DurationControl(),
                        PauseControl(),
                        FlippedSwitch(),
                        CubicControls(),
                        ElasticControls(),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
