import 'package:flutter/material.dart';
import 'package:pharmacy_app/firebase/auth.dart';
import 'package:pharmacy_app/screens/home/tab_view.dart';
import 'package:pharmacy_app/utils/constants.dart';
import 'package:pharmacy_app/utils/dialogs.dart';

class AuthScreen extends StatefulWidget {
  final AuthType authType;
  const AuthScreen({
    Key? key,
    required this.authType,
  }) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(36),
              children: [
                // Image.asset('assets/images/logo.png'),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),
                PasswordTextFormField(controller: _passwordController),
                if (widget.authType == AuthType.signUp)
                  const SizedBox(height: 20),
                if (widget.authType == AuthType.signUp)
                  PasswordTextFormField(
                      controller: _confirmPasswordController,
                      hintText: 'Confirm Password'),
                const SizedBox(height: 50),
                ElevatedButton(
                  style: elevatedButtonStyle,
                  onPressed: () {
                    if (_emailController.text.trim().isEmpty ||
                        _passwordController.text.isEmpty ||
                        (widget.authType == AuthType.signUp &&
                            _confirmPasswordController.text.trim().isEmpty)) {
                      showAlertDialog(context,
                          message: 'One or more fields are empty');
                    } else if (!_emailController.text.trim().contains(RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
                      showAlertDialog(context,
                          message: 'Email address is invalid');
                    } else if (widget.authType == AuthType.signUp &&
                        (_passwordController.text !=
                            _confirmPasswordController.text)) {
                      showAlertDialog(context,
                          message: 'Passwords do not match');
                    } else if (_passwordController.text.length < 6) {
                      showAlertDialog(context,
                          message:
                              'Password should not be less than 6 characters');
                    } else {
                      if (widget.authType == AuthType.login) {
                        _auth.signIn(
                          context,
                          email: _emailController.text.trim(),
                          password: _passwordController.text,
                        );
                      } else {
                        _auth.signUp(context,
                            email: _emailController.text.trim(),
                            password: _passwordController.text);
                      }
                    }
                  },
                  child: Text(
                      widget.authType == AuthType.login ? 'Login' : 'Sign Up'),
                ),
                const SizedBox(height: 30),
                CustomTextSpan(
                  firstText: widget.authType == AuthType.login
                      ? "Don't have an account?"
                      : 'Already have an account?',
                  secondText:
                      widget.authType == AuthType.login ? 'Sign up' : 'Login',
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AuthScreen(
                          authType: widget.authType == AuthType.login
                              ? AuthType.signUp
                              : AuthType.login,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum AuthType { login, signUp }

class CustomTextSpan extends StatelessWidget {
  final String firstText;
  final String secondText;
  final void Function()? onPressed;
  const CustomTextSpan(
      {Key? key,
      required this.firstText,
      required this.secondText,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(firstText),
        TextButton(
          onPressed: onPressed,
          child: Text(
            secondText,
            style: const TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
                color: Colors.blue),
          ),
        ),
      ],
    );
  }
}

class PasswordTextFormField extends StatefulWidget {
  final String? hintText;
  final TextEditingController controller;
  const PasswordTextFormField({
    Key? key,
    this.hintText = 'Password',
    required this.controller,
  }) : super(key: key);

  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  ValueNotifier<bool> obscureText = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: obscureText,
        builder: (context, value, child) {
          return TextFormField(
            controller: widget.controller,
            obscureText: value,
            decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(color: Colors.grey),
                suffixIcon: IconButton(
                    icon: Icon(value ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      obscureText.value = !obscureText.value;
                    })),
          );
        });
  }

  @override
  void dispose() {
    obscureText.dispose();
    super.dispose();
  }
}
