import 'package:flutter/widgets.dart';

class MotionController extends ChangeNotifier {
  MotionController({
    required this.vsync,
  }) : assert(vsync is State, 'vsync must be State');

  final TickerProvider vsync;

  static const Duration _defaultAnimationDuration = Duration(seconds: 1);
  static const Duration _initialPauseDuration = Duration(milliseconds: 500);

  late final AnimationController _controller = AnimationController(
    duration: _defaultAnimationDuration,
    vsync: vsync,
  );

  late final Animation<double> animation = TweenSequence(
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
  ).animate(_controller);

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

  State get state => vsync as State;

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  Future<void> start() async {
    while (state.mounted) {
      await Future<void>.delayed(pauseDuration);
      if (!state.mounted) break;

      while (state.mounted && _controller.value != 0.5) {
        await _controller.animateTo(0.5);
      }
      if (!state.mounted) break;

      await Future<void>.delayed(pauseDuration);
      if (!state.mounted) break;

      while (state.mounted && _controller.value != 1) {
        await _controller.animateTo(1);
      }

      _controller.reset();
    }
  }
}
