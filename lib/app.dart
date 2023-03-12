import 'package:flutter/material.dart';
import 'package:flutter_scope/flutter_scope.dart';

import 'pages/home_page/home_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  static const String title = 'Flutter curves';

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  Brightness? _brightness;
  late Brightness _platformBrightness;

  Brightness get brightness => _brightness ?? _platformBrightness;
  set brightness(Brightness value) {
    setState(() {
      _brightness = value;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _platformBrightness = MediaQuery.of(context).platformBrightness;
  }

  @override
  Widget build(BuildContext context) => Scope(
        value: this,
        child: MaterialApp(
          title: App.title,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              brightness: brightness,
              seedColor: Colors.deepPurple,
              secondary:
                  brightness == Brightness.light ? Colors.red : Colors.yellow,
              tertiary: brightness == Brightness.light
                  ? Colors.blue
                  : Colors.blue.shade700,
            ),
            useMaterial3: true,
          ),
          home: const HomePage(title: App.title),
        ),
      );
}
