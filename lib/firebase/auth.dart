import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/firebase/firestore.dart';
import 'package:pharmacy_app/screens/auth_screen.dart';
import 'package:pharmacy_app/screens/home/tab_view.dart';
import 'package:pharmacy_app/screens/manage_pharmacy/pharmacy_tab_view.dart';
import 'package:pharmacy_app/utils/constants.dart';
import 'package:pharmacy_app/utils/dialogs.dart';

class AuthService {
  FirebaseAuth instance = FirebaseAuth.instance;
  FirestoreService db = FirestoreService();

  User? get currentUser => instance.currentUser;
  String get uid => currentUser!.uid;

  void signUp(BuildContext context,
      {required String email, required String password}) async {
    showLoadingDialog(context, message: 'Creating account...');

    instance
        .createUserWithEmailAndPassword(
          email: email,
          password: password,
        )
        .timeout(ktimeout)
        .then((value) {
      authFunction(context);
    }).onError((error, stackTrace) {
      Navigator.pop(context);

      if (error is FirebaseAuthException) {
        if (error.code == 'weak-password') {
          showAlertDialog(context,
              message: 'The password provided is too weak.');
        } else if (error.code == 'email-already-in-use') {
          showAlertDialog(context,
              message: 'The account already exists for that email.');
        }
      } else {
        showAlertDialog(context);
      }
    });
  }

  signIn(BuildContext context,
      {required String email, required String password}) async {
    showLoadingDialog(context);

    instance
        .signInWithEmailAndPassword(email: email, password: password)
        .timeout(ktimeout)
        .then((value) {
      authFunction(context);
    }).onError((error, stackTrace) {
      Navigator.pop(context);

      if (error is FirebaseAuthException) {
        if (error.code == 'user-not-found') {
          showAlertDialog(context, message: 'No user found for that email.');
        } else if (error.code == 'wrong-password') {
          showAlertDialog(context,
              message: 'Wrong password provided for that user.');
        }
      } else {
        showAlertDialog(context);
      }
    });
  }

  void signOut(BuildContext context) {
    showConfirmationDialog(context, message: 'Sign out?',
        confirmFunction: () async {
      showLoadingDialog(context, message: 'Signing out...');

      instance.signOut().timeout(ktimeout).then((value) {
        authFunction(context);
      }).onError((error, stackTrace) {
        Navigator.pop(context);
        showAlertDialog(context, message: 'Error signing out');
      });
    });
  }

  authFunction(BuildContext context) {
    if (currentUser != null) {
      db.pharmacyDocument().get().timeout(ktimeout).then((value) {
        if (value.data() != null && value.data()!['adminRole'] == 'pharmacy') {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const PharmacyTabView()),
              (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const TabView()),
              (route) => false);
        }

        
      }).onError((error, stackTrace) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ErrorScreen()),
            (route) => false);
      });
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const AuthScreen(authType: AuthType.login)),
          (route) => false);
    }
  }
}

class ErrorScreen extends StatelessWidget {
  ErrorScreen({Key? key}) : super(key: key);

  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Error fetching info'),
            TextButton(
              onPressed: () {
                showLoadingDialog(context);
                auth.authFunction(context);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
