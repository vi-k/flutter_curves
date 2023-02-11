import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class App extends StatefulWidget {
  static const String title = "Curve's Demo";

  const App({super.key});

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
  Widget build(BuildContext context) => Provider.value(
        value: this,
        updateShouldNotify: (_, __) => true,
        child: MaterialApp(
          title: App.title,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              brightness: brightness,
              seedColor: Colors.deepPurple,
              secondary: brightness == Brightness.light
                  ? Colors.cyan
                  : Colors.cyan.shade800,
            ),
            useMaterial3: true,
          ),
          home: const HomePage(title: App.title),
        ),
      );
}
