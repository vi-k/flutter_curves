import 'dart:async';

import 'package:flutter/widgets.dart';

/// Drives every motion and the curve graph on a screen from one ticker.
///
/// The animation it exposes is not a plain `0 -> 1`: it is a sequence of
/// `0 -> 1` and then `-1 -> 0`, so the sign of the value tells the painters
/// which leg of the run they are on. A negative value is the way back.
class MotionController extends ChangeNotifier {
  /// Creates a controller bound to [vsync].
  MotionController({required TickerProvider vsync})
    : _controller = AnimationController(
        duration: _defaultAnimationDuration,
        vsync: vsync,
      );

  static const Duration _defaultAnimationDuration = Duration(seconds: 1);
  static const Duration _initialPauseDuration = Duration(milliseconds: 500);

  final AnimationController _controller;

  /// Whether [dispose] has been called.
  ///
  /// [start] loops until this turns true. The controller owns the flag rather
  /// than reading `mounted` off a `State`: the loop outlives any single frame,
  /// and the only thing that may stop it is the end of the controller itself.
  bool _disposed = false;

  /// The timer of the pause [start] is currently sitting in, if any.
  Timer? _pauseTimer;
  Completer<void>? _pauseCompleter;

  late final Animation<double> animation = TweenSequence([
    TweenSequenceItem(tween: Tween<double>(begin: 0, end: 1), weight: 1),
    TweenSequenceItem(tween: Tween<double>(begin: -1, end: 0), weight: 1),
  ]).animate(_controller);

  Duration get animationDuration => _controller.duration!;
  set animationDuration(Duration value) {
    _controller
      ..stop(canceled: false)
      ..duration = value;
    notifyListeners();
  }

  Duration get pauseDuration => _pauseDuration;
  Duration _pauseDuration = _initialPauseDuration;
  set pauseDuration(Duration value) {
    _pauseDuration = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _endPause();
    _controller.dispose();

    super.dispose();
  }

  /// Waits out the pause between two legs of the run.
  ///
  /// A plain `Future.delayed` would do, were it not for the timer it leaves
  /// behind: the loop is endless, so there is always one pending, and a widget
  /// test that ends mid-pause fails on it. This one is cancelled by [dispose].
  Future<void> _pause() {
    final completer = _pauseCompleter = Completer<void>();
    _pauseTimer = Timer(pauseDuration, _endPause);

    return completer.future;
  }

  /// Ends the current pause early, releasing [start] to see [_disposed].
  void _endPause() {
    _pauseTimer?.cancel();
    _pauseTimer = null;

    final completer = _pauseCompleter;
    _pauseCompleter = null;
    if (completer != null && !completer.isCompleted) completer.complete();
  }

  /// Runs the animation in a loop until the controller is disposed of.
  ///
  /// Each pass is a pause, the forward leg, another pause and the way back.
  /// The inner loops retry because changing [animationDuration] stops the
  /// controller mid-leg, and the leg has to be finished at the new speed.
  Future<void> start() async {
    while (!_disposed) {
      await _pause();
      if (_disposed) break;

      while (!_disposed && _controller.value != 0.5) {
        await _controller.animateTo(0.5);
      }
      if (_disposed) break;

      await _pause();
      if (_disposed) break;

      while (!_disposed && _controller.value != 1) {
        await _controller.animateTo(1);
      }
      if (_disposed) break;

      _controller.reset();
    }
  }
}
