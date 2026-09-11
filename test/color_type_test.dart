import 'package:flutter/material.dart';
import 'package:flutter_curves/motions/export.dart';
import 'package:flutter_test/flutter_test.dart';

import 'motion_test_helpers.dart';

void main() {
  test('draft colors resolve every state slot and apply opacity', () {
    final state = createMotionState(
      boxColor: const Color(0xff102030),
      alternateColor: const Color(0xff405060),
      textOnBoxColor: const Color(0xff708090),
      textOutBoxColor: const Color(0xffa0b0c0),
    );

    final colors = [
      const DraftColor.box(0.5).colorFrom(state),
      const DraftColor.alternate(0.5).colorFrom(state),
      const DraftColor.textOnBox(0.5).colorFrom(state),
      const DraftColor.textOutBox(0.5).colorFrom(state),
    ];
    final expected = [
      const Color(0xff102030),
      const Color(0xff405060),
      const Color(0xff708090),
      const Color(0xffa0b0c0),
    ];

    for (var i = 0; i < colors.length; i++) {
      expect(colors[i].a, 0.5);
      expect(colors[i].r, expected[i].r);
      expect(colors[i].g, expected[i].g);
      expect(colors[i].b, expected[i].b);
    }
  });

  test('finished draft colors choose the theme-specific color', () {
    const draft = DraftColor(Color(0xff112233), Color(0xffaabbcc));

    expect(draft.colorFrom(createMotionState()), const Color(0xff112233));
    expect(
      draft.colorFrom(createMotionState(brightness: Brightness.dark)),
      const Color(0xffaabbcc),
    );
  });

  test('draft colors can be created from an object color type', () {
    final state = createMotionState(boxColor: const Color(0xff102030));

    final draft = DraftColor.byColorType(ObjectColor.box, 0.25);

    expect(draft.colorFrom(state).a, 0.25);
    expect(draft.colorFrom(state).r, const Color(0xff102030).r);
  });

  test('object colors read initial and current values and can write them', () {
    final state = createMotionState()..boxColor = const Color(0xff445566);

    const color = ObjectColor.box;

    expect(color.initialColorFrom(state), const Color(0xff112233));
    expect(color.colorFrom(state), const Color(0xff445566));

    color.setColorTo(state, const Color(0xff778899));

    expect(state.boxColor, const Color(0xff778899));
  });

  test('each object color targets its own slot', () {
    final state = createMotionState();

    ObjectColor.textOnBox.setColorTo(state, const Color(0xff010203));
    ObjectColor.textOutBox.setColorTo(state, const Color(0xff040506));

    expect(state.textOnBoxColor, const Color(0xff010203));
    expect(state.textOutBoxColor, const Color(0xff040506));
    expect(state.boxColor, const Color(0xff112233));
  });
}
