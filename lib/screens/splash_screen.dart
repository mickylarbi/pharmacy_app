import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pharmacy_app/firebase/auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    AuthService auth = AuthService();
    Future.delayed(const Duration(seconds: 1), () {
      auth.authFunction(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
