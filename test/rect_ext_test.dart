import 'dart:ui';

import 'package:flutter_curves/motions/export.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('rect alignment constructors place boxes in the expected cells', () {
    final rects = [
      const RectExt.full(),
      const RectExt.topLeft(width: 0.5, height: 0.25),
      const RectExt.topCenter(width: 0.5, height: 0.25),
      const RectExt.topRight(width: 0.5, height: 0.25),
      const RectExt.centerLeft(width: 0.5, height: 0.25),
      const RectExt.center(width: 0.5, height: 0.25),
      const RectExt.centerRight(width: 0.5, height: 0.25),
      const RectExt.bottomLeft(width: 0.5, height: 0.25),
      const RectExt.bottomCenter(width: 0.5, height: 0.25),
      const RectExt.bottomRight(width: 0.5, height: 0.25),
    ];
    final expected = [
      const Rect.fromLTRB(-1, -1, 1, 1),
      const Rect.fromLTWH(-1, -1, 0.5, 0.25),
      const Rect.fromLTWH(-0.25, -1, 0.5, 0.25),
      const Rect.fromLTWH(0.5, -1, 0.5, 0.25),
      const Rect.fromLTWH(-1, -0.125, 0.5, 0.25),
      const Rect.fromLTWH(-0.25, -0.125, 0.5, 0.25),
      const Rect.fromLTWH(0.5, -0.125, 0.5, 0.25),
      const Rect.fromLTWH(-1, 0.75, 0.5, 0.25),
      const Rect.fromLTWH(-0.25, 0.75, 0.5, 0.25),
      const Rect.fromLTWH(0.5, 0.75, 0.5, 0.25),
    ];

    for (var i = 0; i < rects.length; i++) {
      expect(rects[i].left, expected[i].left);
      expect(rects[i].top, expected[i].top);
      expect(rects[i].right, expected[i].right);
      expect(rects[i].bottom, expected[i].bottom);
    }
  });

  test('side constructors span the requested extent', () {
    final rects = [
      const RectExt.left(width: 0.4),
      const RectExt.right(width: 0.4),
      const RectExt.top(height: 0.4),
      const RectExt.bottom(height: 0.4),
    ];
    final expected = [
      const Rect.fromLTWH(-1, -1, 0.4, 2),
      const Rect.fromLTWH(0.6, -1, 0.4, 2),
      const Rect.fromLTWH(-1, -1, 2, 0.4),
      const Rect.fromLTWH(-1, 0.6, 2, 0.4),
    ];

    for (var i = 0; i < rects.length; i++) {
      expect(rects[i].left, expected[i].left);
      expect(rects[i].top, expected[i].top);
      expect(rects[i].right, expected[i].right);
      expect(rects[i].bottom, expected[i].bottom);
    }
  });
}
