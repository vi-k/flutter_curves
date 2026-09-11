import 'package:flutter/material.dart';
import 'package:flutter_curves/motions/export.dart';
import 'package:flutter_test/flutter_test.dart';

import 'motion_test_helpers.dart';

void main() {
  test('motion state exposes its initial values and derived rounded rect', () {
    final state = createMotionState(
      rect: const Rect.fromLTWH(1, 2, 10, 20),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(3),
        bottomRight: Radius.circular(4),
      ),
    );
    expect(state.initialRect, const Rect.fromLTWH(1, 2, 10, 20));
    expect(state.initialBorderRadius.topLeft, const Radius.circular(3));
    expect(state.initialBoxColor, const Color(0xff112233));
    expect(state.initialTextOnBoxColor, const Color(0xff445566));
    expect(state.initialTextOutBoxColor, const Color(0xff778899));
    expect(state.rrect.outerRect, state.rect);
    expect(state.rrect.tlRadius, const Radius.circular(3));
    expect(state.rrect.brRadius, const Radius.circular(4));

    state
      ..borderRadius = BorderRadius.zero
      ..boxColor = const Color(0xff010203)
      ..textOnBoxColor = const Color(0xff040506)
      ..textOutBoxColor = const Color(0xff070809);

    expect(state.initialBorderRadius.topLeft, const Radius.circular(3));
    expect(state.initialBoxColor, const Color(0xff112233));
    expect(state.initialTextOnBoxColor, const Color(0xff445566));
    expect(state.initialTextOutBoxColor, const Color(0xff778899));
  });

  test('save copies mutable state and can replace the child rectangle', () {
    final state = createMotionState(rect: const Rect.fromLTWH(0, 0, 10, 10));
    final saved = state.save(const Rect.fromLTWH(5, 6, 7, 8))
      ..rect = const Rect.fromLTWH(9, 9, 1, 1)
      ..borderRadius = BorderRadius.zero
      ..boxColor = const Color(0xffabcdef);

    expect(state.rect, const Rect.fromLTWH(0, 0, 10, 10));
    expect(state.borderRadius, isNot(BorderRadius.zero));
    expect(state.boxColor, const Color(0xff112233));
    expect(saved.initialRect, const Rect.fromLTWH(5, 6, 7, 8));
    expect(
      saved.initialBorderRadius,
      const BorderRadius.all(Radius.circular(MotionState.defaultCorner)),
    );
    expect(saved.initialBoxColor, const Color(0xff112233));
    expect(saved.initialTextOnBoxColor, const Color(0xff445566));
    expect(saved.initialTextOutBoxColor, const Color(0xff778899));
  });

  // The copy has to carry the current values, not the ones the state was
  // built with. Every field here is moved off its default first: while
  // borderRadius still equals initialBorderRadius, a copy taking either
  // of them looks exactly the same.
  test('save carries the current values, not the initial ones', () {
    final state = createMotionState(rect: const Rect.fromLTWH(0, 0, 10, 10))
      ..borderRadius = const BorderRadius.all(Radius.circular(7))
      ..boxColor = const Color(0xff010203)
      ..textOnBoxColor = const Color(0xff040506)
      ..textOutBoxColor = const Color(0xff070809);

    final saved = state.save();

    expect(saved.borderRadius, const BorderRadius.all(Radius.circular(7)));
    expect(saved.boxColor, const Color(0xff010203));
    expect(saved.textOnBoxColor, const Color(0xff040506));
    expect(saved.textOutBoxColor, const Color(0xff070809));
  });

  test('restore returns the canvas to the state before save', () async {
    final image = await renderCanvas((canvas) {
      final state = createMotionState(canvas: canvas);
      final saved = state.save();
      canvas
        ..translate(10, 0)
        ..drawRect(const Rect.fromLTWH(0, 0, 2, 2), Paint());
      saved.restore();
      canvas.drawRect(const Rect.fromLTWH(0, 4, 2, 2), Paint());
    });

    expect(await readPixel(image, 11, 1), const Color(0xff000000));
    expect(await readPixel(image, 1, 5), const Color(0xff000000));
    expect(await readPixel(image, 1, 1), const Color(0x00000000));
    image.dispose();
  });
}
