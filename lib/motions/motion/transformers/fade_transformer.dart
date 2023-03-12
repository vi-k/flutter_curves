import '../color_type.dart';
import '../motion_state.dart';
import 'motion_transformer.dart';

class FadeTransformer extends MotionTransformerDouble {
  const FadeTransformer({
    this.colors = const {
      ObjectColor.box,
      ObjectColor.textOnBox,
      ObjectColor.textOutBox,
    },
    double? begin,
    double? end,
  }) : super(
          begin: begin ?? 0,
          end: end ?? 1,
        );

  final Set<ObjectColor> colors;

  @override
  void transform(MotionState state, double transformedValue) {
    final value = transformedValue.clamp(0.0, 1.0);

    for (final c in colors) {
      final color = c.initialColorFrom(state);
      c.setColorTo(state, color.withOpacity(color.opacity * value));
    }
  }
}
