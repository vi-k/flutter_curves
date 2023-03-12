import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_scope/flutter_scope.dart';

import '../../motions/export.dart';
import '../home_page/home_page_controller.dart';
import 'motions_dialog.dart';

class MotionsDIalogController extends ScopeChildController<HomePageController>
    with
        ScopeWidgetProviderMixin<MotionsDialog>,
        ScopeControllerSingleTickerProviderMixin {
  MotionsDIalogController(super.parent);

  final Set<MotionObject> alreadyOnList = {};

  MotionController? _motionController;
  late MotionObject? _selectedMotion;

  Animation<double> get animation =>
      widget.animation ?? _motionController!.animation;

  MotionObject? get selectedMotion => _selectedMotion;

  @override
  void initScope() {
    super.initScope();

    if (widget.animation == null) {
      final mc = _motionController = MotionController(vsync: $scopeState)
        ..animationDuration = parent.motionController.animationDuration
        ..pauseDuration = parent.motionController.pauseDuration;

      unawaited(mc.start());
    }

    _selectedMotion = widget.selectedMotion;
  }

  @override
  void dispose() {
    _motionController?.dispose();

    super.dispose();
  }

  void select(MotionObject value) {
    _selectedMotion = value;
    notifyListeners();
    if (mounted) Navigator.pop(context, value);
  }
}
