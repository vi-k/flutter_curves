import 'package:flutter/widgets.dart';
import 'package:flutter_scope/flutter_scope.dart';

import '../../animations/export.dart';
import '../home_page/home_page_controller.dart';
import 'animations_page.dart';

class AnimationsPageController extends ScopeChildController<HomePageController>
    with
        ScopeWidgetProviderMixin<AnimationsPage>,
        ScopeControllerSingleTickerProviderMixin {
  final Set<AnimationSettings> alreadyOnList = {};

  ControllerForAnimations? _animationController;
  late AnimationSettings? _selected;

  AnimationsPageController(super.parent);

  Animation<double> get animation =>
      widget.animation ?? _animationController!.animation;

  AnimationSettings? get selected => _selected;

  @override
  void initScope() {
    super.initScope();

    if (widget.animation == null) {
      _animationController = ControllerForAnimations(
        vsync: $scopeState,
      )
        ..animationDuration = parent.controllerForAnimations.animationDuration
        ..pauseDuration = parent.controllerForAnimations.pauseDuration
        ..start();
    }

    _selected = widget.selected;
  }

  @override
  void dispose() {
    _animationController?.dispose();

    super.dispose();
  }

  Future<void> select(AnimationSettings value) async {
    _selected = value;
    notifyListeners();
    // await Future<void>.delayed(const Duration(milliseconds: 300));
    await Future<void>.delayed(Duration.zero);
    if (mounted) Navigator.pop(context, value);
  }
}
