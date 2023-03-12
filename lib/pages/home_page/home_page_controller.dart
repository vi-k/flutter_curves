import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scope/flutter_scope.dart';

import '../../common/dialog_for_page_route.dart';
import '../../motions/export.dart';
import '../motions_page/motions_dialog.dart';

class HomePageController extends ScopeController
    with ScopeControllerSingleTickerProviderMixin {
  static const double _initialCubicA = 0.25;
  static const double _initialCubicB = 0.1;
  static const double _initialCubicC = 0.25;
  static const double _initialCubicD = 1;
  static const int _initialElasticType = 0;
  static const double _initialElasticPeriod = 0.4;
  static const bool _initialFlipped = true;

  MotionController get motionController => _motionController;
  late final MotionController _motionController;

  Curve get curve => _curve;
  late Curve _curve;
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
  double _cubicA = _initialCubicA;
  set cubicA(double value) {
    _cubicA = value;
    _assemblyCubic();
  }

  double get cubicB => _cubicB;
  double _cubicB = _initialCubicB;
  set cubicB(double value) {
    _cubicB = value;
    _assemblyCubic();
  }

  double get cubicC => _cubicC;
  double _cubicC = _initialCubicC;
  set cubicC(double value) {
    _cubicC = value;
    _assemblyCubic();
  }

  double get cubicD => _cubicD;
  double _cubicD = _initialCubicD;
  set cubicD(double value) {
    _cubicD = value;
    _assemblyCubic();
  }

  int get elasticType => _elasticType;
  int _elasticType = _initialElasticType;
  set elasticType(int value) {
    _elasticType = value;
    _assemblyElastic();
  }

  double get elasticPeriod => _elasticPeriod;
  double _elasticPeriod = _initialElasticPeriod;
  set elasticPeriod(double value) {
    _elasticPeriod = (value * 100).roundToDouble() / 100;
    _assemblyElastic();
  }

  bool get flipped => _flipped;
  bool _flipped = _initialFlipped;
  set flipped(bool value) {
    _flipped = value;
    notifyListeners();
  }

  Color get boxColor => _boxColor;
  late Color _boxColor;

  Color get alternateColor => _alternateColor;
  late Color _alternateColor;

  Color get textOnBoxColor => _textOnBoxColor;
  late Color _textOnBoxColor;

  Color get textOutBoxColor => _textOutBoxColor;
  late Color _textOutBoxColor;

  IList<MotionObject> get firstMotions => _firstMotions;
  late IList<MotionObject> _firstMotions;

  IList<MotionObject> get secondMotions => _secondMotions;
  late IList<MotionObject> _secondMotions;

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

    _motionController = MotionController(
      vsync: $scopeState,
    )..start(); // ignore: discarded_futures

    _firstMotions = defaultFirstMotions;
    _secondMotions = defaultSecondMotions;
  }

  @override
  void didChangeDependencies() {
    final theme = Theme.of(context);

    _boxColor = theme.colorScheme.primary;
    _alternateColor = theme.colorScheme.secondary;
    _textOnBoxColor = theme.colorScheme.onPrimary;
    _textOutBoxColor = theme.colorScheme.onBackground;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _motionController.dispose();

    super.dispose();
  }

  void selectFirstMotion(String heroTag, int index) =>
      // ignore: discarded_futures
      _selectMotion(heroTag, index, first: true);

  void selectSecondMotion(String heroTag, int index) =>
      // ignore: discarded_futures
      _selectMotion(heroTag, index, first: false);

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

    if (newMotion != null) {
      if (first) {
        _firstMotions = _firstMotions.put(index, newMotion);
      } else {
        _secondMotions = _secondMotions.put(index, newMotion);
      }
      notifyListeners();
    }
  }
}
