import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_curves/motions/export.dart';
import 'package:flutter_test/flutter_test.dart';

import 'motion_test_helpers.dart';

class _RecordingTransformer extends MotionTransformer<Object> {
  _RecordingTransformer(this.events) : super(begin: 'begin', end: 'end');

  final List<String> events;

  @override
  Object transformedValue(MotionState state, double value) => value;

  @override
  void prepare(MotionState state) {
    events.add('prepare');
    super.prepare(state);
  }

  @override
  void transform(MotionState state, Object transformedValue) {
    events.add('transform');
  }

  @override
  void finalize(MotionState state) {
    events.add('finalize');
    super.finalize(state);
  }
}

class _RecordingObject extends MotionObject {
  const _RecordingObject(this.events, {this.onPaint});

  final List<String> events;
  final void Function(MotionState state)? onPaint;

  @override
  void paint(MotionState state, double value) {
    events.add('child');
    onPaint?.call(state);
    super.paint(state, value);
  }
}

void main() {
  test('motion objects apply transformers before painting children', () {
    final events = <String>[];
    final transformer = _RecordingTransformer(events);
    Motions(
      transformers: IListConst<MotionTransformer<Object>>([transformer]),
      children: IListConst<MotionObject>([_RecordingObject(events)]),
    ).paint(createMotionState(), 0.5);

    expect(events, ['prepare', 'transform', 'finalize', 'child']);
  });

  test('each child receives an isolated state and canvas save', () async {
    final events = <String>[];
    final image = await renderCanvas((canvas) {
      Motions(
        rect: const Rect.fromLTWH(5, 6, 7, 8),
        children: IListConst<MotionObject>([
          _RecordingObject(
            events,
            onPaint: (state) {
              expect(state.rect, const Rect.fromLTWH(5, 6, 7, 8));
              state.rect = Rect.zero;
              state.canvas.translate(10, 0);
              state.canvas.drawRect(const Rect.fromLTWH(0, 0, 2, 2), Paint());
            },
          ),
          _RecordingObject(
            events,
            onPaint: (state) {
              expect(state.rect, const Rect.fromLTWH(5, 6, 7, 8));
              state.canvas.drawRect(const Rect.fromLTWH(0, 4, 2, 2), Paint());
            },
          ),
        ]),
      ).paint(createMotionState(canvas: canvas), 0);
    });

    expect(await readPixel(image, 11, 1), const Color(0xff000000));
    expect(await readPixel(image, 1, 5), const Color(0xff000000));
    expect(await readPixel(image, 1, 1), const Color(0x00000000));
    expect(events, ['child', 'child']);
    image.dispose();
  });

  test(
    'fill and border draw with the state rectangle and draft color',
    () async {
      final fillImage = await renderCanvas((canvas) {
        final state = createMotionState(
          canvas: canvas,
          rect: const Rect.fromLTWH(4, 4, 12, 12),
          borderRadius: BorderRadius.zero,
          boxColor: const Color(0xff123456),
        );
        const MotionFill().paint(state, 0);
      });
      final borderImage = await renderCanvas((canvas) {
        final state = createMotionState(
          canvas: canvas,
          px: 1,
          rect: const Rect.fromLTWH(4, 4, 12, 12),
          borderRadius: BorderRadius.zero,
          boxColor: const Color(0xffabcdef),
        );
        const MotionBorder().paint(state, 0);
      });

      expect(await readPixel(fillImage, 8, 8), const Color(0xff123456));
      expect(await readPixel(borderImage, 4, 8), const Color(0xffabcdef));
      expect(await readPixel(borderImage, 8, 8), const Color(0x00000000));
      fillImage.dispose();
      borderImage.dispose();
    },
  );

  test('motion icon exposes its glyph text and font family', () {
    const icon = MotionIcon(Icons.star);

    expect(icon.text, String.fromCharCode(Icons.star.codePoint));
    expect(icon.fontFamily, Icons.star.fontFamily);
  });

  test('motion text paints its paragraph inside the state rectangle', () async {
    final image = await renderCanvas((canvas) {
      final state = createMotionState(
        canvas: canvas,
        rect: const Rect.fromLTWH(4, 4, 30, 20),
        textOnBoxColor: const Color(0xff123456),
      );
      const MotionText('A', fontSize: 10).paint(state, 0);
    });

    var foundInk = false;
    for (var y = 4; y < 24 && !foundInk; y++) {
      for (var x = 4; x < 34; x++) {
        if ((await readPixel(image, x, y)).a != 0) {
          foundInk = true;
          break;
        }
      }
    }

    expect(foundInk, isTrue);
    image.dispose();
  });
}
