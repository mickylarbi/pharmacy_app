import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pharmacy_app/firebase/auth.dart';
import 'package:pharmacy_app/utils/constants.dart';

class PharmacyTabView extends StatefulWidget {
  const PharmacyTabView({super.key});

  @override
  State<PharmacyTabView> createState() => _PharmacyTabViewState();
}

class _PharmacyTabViewState extends State<PharmacyTabView> {
  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            auth.signOut(context);
          },
          style: translucentButtonStyle,
          child: const Text('sign out'),
        ),
      ),
    );
  }
}
