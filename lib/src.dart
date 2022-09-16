import 'package:flutter/material.dart';
import 'package:pharmacy_app/main.dart';
import 'package:pharmacy_app/screens/auth_screen.dart';
import 'package:pharmacy_app/screens/home/tab_view.dart';

class Src extends StatelessWidget {
  const Src({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const AuthScreen(authType: AuthType.login),
    );
  }
}
