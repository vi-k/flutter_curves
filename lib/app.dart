import 'package:flutter/material.dart';
import 'package:scopo/scopo.dart';

import 'pages/home_page/home_page.dart';

/// The application scope.
///
/// Owns the brightness override and builds the [MaterialApp] that every theme
/// lookup below it resolves against.
final class App extends LiteScope<App, AppState> {
  const App({super.key});

  static const String title = 'Flutter curves';

  /// The type arguments of this scope, named once.
  static const access = LiteScopeAccess<App, AppState>();

  @override
  Widget? buildOnWaiting(BuildContext context) => const SizedBox.shrink();

  @override
  AppState createState() => AppState();
}

/// The state of the [App] scope.
final class AppState extends LiteScopeState<App, AppState> {
  Brightness? _brightness;
  late Brightness _platformBrightness;

  /// The brightness in force: the override if there is one, the platform's
  /// otherwise.
  Brightness get brightness => _brightness ?? _platformBrightness;
  set brightness(Brightness value) {
    setState(() {
      _brightness = value;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _platformBrightness = MediaQuery.platformBrightnessOf(context);
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: App.title,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        brightness: brightness,
        seedColor: Colors.deepPurple,
        secondary: brightness == Brightness.light ? Colors.red : Colors.yellow,
        tertiary: brightness == Brightness.light
            ? Colors.blue
            : Colors.blue.shade700,
      ),
    ),
    home: const HomePage(title: App.title),
  );
}
