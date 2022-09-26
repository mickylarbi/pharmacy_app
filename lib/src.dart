import 'package:flutter/material.dart';
import 'package:pharmacy_app/screens/splash_screen.dart';

class Src extends StatelessWidget {
  const Src({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const SplashScreen(),
    );
  }
}
