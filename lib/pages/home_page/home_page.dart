import 'dart:async';

import 'package:flutter/material.dart';

import '../../motions/export.dart';
import 'home_scope.dart';

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
