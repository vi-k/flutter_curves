import 'package:flutter/material.dart';
import 'package:flutter_curves/common/dialog_for_page_route.dart';
import 'package:flutter_test/flutter_test.dart';

/// Marks the content handed to the route, so the tests can measure it.
const _dialogKey = ValueKey<String>('dialog');

/// The entrance transition of [DialogForPageRoute].
const _transition = Duration(milliseconds: 500);

/// Long enough for the reverse transition and the route's removal.
const _dismissal = Duration(milliseconds: 500);

/// Opens a dialog [height] pixels tall and pumps the entrance transition.
///
/// Nothing is pumped beyond the transition: the dialog is expected to arrive
/// in its final place, so the tests measure the tree the moment it lands.
Future<void> _openDialog(WidgetTester tester, {required double height}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () => Navigator.of(context).push(
            DialogForPageRoute<void>(
              barrierDismissible: true,
              builder: (_) => SizedBox(key: _dialogKey, height: height),
            ),
          ),
          child: const Text('open'),
        ),
      ),
    ),
  );

  await tester.tap(find.text('open'));
  await tester.pump();
  await tester.pump(_transition);
}

/// Drives frames until a fling started by [WidgetTester.drag] has run out.
Future<void> _pumpBallistic(WidgetTester tester) async {
  for (var frame = 0; frame < 10; frame++) {
    await tester.pump(const Duration(milliseconds: 200));
  }
}

void main() {
  testWidgets('a short dialog arrives already centred', (tester) async {
    await _openDialog(tester, height: 100);

    final screen = tester.getSize(find.byType(MaterialApp));
    final dialog = tester.getRect(find.byKey(_dialogKey));

    expect(dialog.center.dy, moreOrLessEquals(screen.height / 2, epsilon: 0.5));
  });

  testWidgets('a tap above the dialog reaches the barrier', (tester) async {
    await _openDialog(tester, height: 100);

    final dialog = tester.getRect(find.byKey(_dialogKey));
    await tester.tapAt(Offset(dialog.center.dx, dialog.top / 2));
    await tester.pump();
    await tester.pump(_dismissal);

    expect(find.byKey(_dialogKey), findsNothing);
  });

  testWidgets('a tap below the dialog reaches the barrier', (tester) async {
    await _openDialog(tester, height: 100);

    final screen = tester.getSize(find.byType(MaterialApp));
    final dialog = tester.getRect(find.byKey(_dialogKey));
    await tester.tapAt(
      Offset(dialog.center.dx, (dialog.bottom + screen.height) / 2),
    );
    await tester.pump();
    await tester.pump(_dismissal);

    expect(find.byKey(_dialogKey), findsNothing);
  });

  testWidgets('a dialog scrolled to its end stops laying out', (tester) async {
    await _openDialog(tester, height: 2000);

    await tester.drag(find.byType(Scrollable), const Offset(0, -3000));
    await _pumpBallistic(tester);

    expect(tester.binding.hasScheduledFrame, isFalse);
  });
}
