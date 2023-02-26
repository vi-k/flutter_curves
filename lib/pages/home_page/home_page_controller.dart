import 'package:flutter/material.dart';
import 'package:flutter_scope/flutter_scope.dart';

import '../../animations/export.dart';
import '../../common/dialog_for_page_route.dart';
import '../animations_page/animations_page.dart';

class HomePageController extends ScopeController
    with ScopeControllerSingleTickerProviderMixin {
  late final ControllerForAnimations _controllerForAnimations;
  late Curve _curve;
  double _cubicA = 0.25;
  double _cubicB = 0.1;
  double _cubicC = 0.25;
  double _cubicD = 1;
  double _elasticPeriod = 0.4;
  int _elasticType = 0;
  bool _flipped = true;
  late Color _boxColor;
  late Color _alternateColor;
  late Color _textOnBoxColor;
  late Color _textOutBoxColor;
  late final List<AnimationSettings> _firstAnimations;
  late final List<AnimationSettings> _secondAnimations;

  ControllerForAnimations get controllerForAnimations =>
      _controllerForAnimations;

  Curve get curve => _curve;
  set curve(Curve value) {
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
    notifyListeners();
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

  bool get flipped => _flipped;
  set flipped(bool value) {
    _flipped = value;
    notifyListeners();
  }

  Color get boxColor => _boxColor;
  Color get alternateColor => _alternateColor;
  Color get textOnBoxColor => _textOnBoxColor;
  Color get textOutBoxColor => _textOutBoxColor;

  List<AnimationSettings> get firstAnimations => _firstAnimations;
  List<AnimationSettings> get secondAnimations => _secondAnimations;

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
  void initScope() {
    super.initScope();

    curve = Curves.ease;

    _controllerForAnimations = ControllerForAnimations(
      vsync: $scopeState,
    )..start();

    _firstAnimations = List.of(defaultFirstAnimations);
    _secondAnimations = List.of(defaultSecondAnimations);
  }

  @override
  void dispose() {
    _controllerForAnimations.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    final theme = Theme.of(context);

    _boxColor = theme.colorScheme.primary;
    _alternateColor = theme.colorScheme.secondary;
    _textOnBoxColor = theme.colorScheme.onPrimary;
    _textOutBoxColor = _boxColor;

    super.didChangeDependencies();
  }

  Future<void> selectAnimation(
    List<AnimationSettings> animations,
    String heroTag,
    int index,
  ) async {
    final newAnimation = await Navigator.of(context).push<AnimationSettings>(
      DialogForPageRoute(
        barrierDismissible: true,
        builder: (_) => AnimationsPage(
          parent: this,
          animation: controllerForAnimations.animation,
          selected: animations[index],
          selectedHeroTag: heroTag,
        ),
      ),
    );

    if (newAnimation != null) {
      animations[index] = newAnimation;
      notifyListeners();
    }
  }
}
