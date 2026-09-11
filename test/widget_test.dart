import 'package:flutter/material.dart';
import 'package:flutter_curves/app.dart';
import 'package:flutter_curves/motions/export.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps frames until [condition] holds, or fails after [maxFrames].
///
/// `pumpAndSettle` cannot be used here: the motions animate in an endless
/// loop, so the tree never settles. The scopes also reach their ready branch
/// over several frames rather than the first one.
Future<void> _pumpUntil(
  WidgetTester tester,
  bool Function() condition, {
  int maxFrames = 20,
  Duration step = Duration.zero,
}) async {
  for (var frame = 0; frame < maxFrames; frame++) {
    if (condition()) return;
    await tester.pump(step);
  }

  fail('the condition did not hold within $maxFrames frames');
}

/// Brings the application up and waits until both scopes have settled.
///
/// Settling matters beyond the first frame the screen appears on: a scope
/// subscribes its descendants wholesale until its ready branch is built, so a
/// widget built during the transition is rebuilt by any notification at all.
/// Only after that does a `select` mean what it says.
Future<void> _pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(const App());
  await _pumpUntil(tester, () => find.text(App.title).evaluate().isNotEmpty);
  await tester.pump();
  await tester.pump();
}

void main() {
  testWidgets('the home screen comes up with its controls', (tester) async {
    await _pumpApp(tester);

    expect(find.text(App.title), findsOneWidget);
    expect(find.text('Duration:'), findsOneWidget);
    expect(find.text('Pause:'), findsOneWidget);
    expect(find.text('Flip it over when it goes back:'), findsOneWidget);
    expect(find.text('Curves.ease'), findsWidgets);
  });

  testWidgets('the theme switch reaches the app scope', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.byIcon(Icons.mode_night));
    await _pumpUntil(
      tester,
      () => find.byIcon(Icons.mode_night).evaluate().isEmpty,
      step: const Duration(milliseconds: 100),
    );

    expect(find.byIcon(Icons.light_mode), findsOneWidget);
    expect(
      Theme.of(tester.element(find.byType(Scaffold))).brightness,
      Brightness.dark,
    );
  });

  testWidgets('tapping a motion opens the picker', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.byType(Motion).first, warnIfMissed: false);
    await _pumpUntil(
      tester,
      () => find.text('Select a motion').evaluate().isNotEmpty,
      step: const Duration(milliseconds: 100),
    );

    // The picker is a scope of its own, reading the curve and the colours of
    // the home scope it was handed as a parameter.
    expect(find.text('Translate:'), findsOneWidget);
    expect(find.text('Matrix:'), findsOneWidget);
  });

  testWidgets('a cubic slider rebuilds the curve readout', (tester) async {
    await _pumpApp(tester);

    expect(find.text('Cubic(0.25, 0.10, 0.25, 1.00)'), findsOneWidget);

    await tester.tap(find.byType(Slider).first);
    await tester.pump();

    expect(find.text('Cubic(0.25, 0.10, 0.25, 1.00)'), findsNothing);
    expect(find.textContaining('Cubic('), findsWidgets);
  });
}
