import 'package:flutter/material.dart';

import 'home.dart';

class App extends StatelessWidget {
  static const String title = "Curve's Demo";

  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: title,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            secondary: Colors.cyan,
          ),
          useMaterial3: true,
        ),
        home: const HomePage(title: title),
      );
}
