import 'package:flutter/material.dart';
import 'package:waste_time/authenticate/register.dart';
import 'package:waste_time/authenticate/signin.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return const SignIn();
    } else {
      return const Register();
    }
  }
}
