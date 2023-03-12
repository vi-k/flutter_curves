import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../motion_state.dart';
import '../transformers/motion_transformer.dart';

@immutable
abstract class MotionObject {
  const MotionObject({
    this.rect,
    IList<MotionTransformer<Object>>? transformers,
    IList<MotionObject>? children,
    this.clip = true,
  })  : transformers = transformers ?? const IListConst([]),
        children = children ?? const IListConst([]);

  final Rect? rect;
  final IList<MotionTransformer<Object>> transformers;
  final IList<MotionObject> children;
  final bool clip;

  void prepare(MotionState state) {
    state.save();
    if (rect != null) {
      state.rect = rect!;
    }
  }

  @mustCallSuper
  void paint(MotionState state, double value) {
    for (final transformer in transformers) {
      transformer
        ..prepare(state)
        ..calculateAndTransform(state, value)
        ..finalize(state);
    }

    for (final child in children) {
      final stateCopy = state.save(rect);
      child.paint(stateCopy, value);
      state.restore();
    }
  }

  void finalized(MotionState state) {
    state.restore();
  }
}
