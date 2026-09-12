import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../home_scope.dart';
import 'duration_select.dart';

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

class DurationControl extends StatelessWidget {
  const DurationControl({super.key});

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

class PauseControl extends StatelessWidget {
  const PauseControl({super.key});

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
