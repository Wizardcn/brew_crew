import 'package:brew_crew/screens/authenticate/register.dart';
import 'package:brew_crew/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Authenticate extends StatefulWidget {
  bool showSignIn;

  Authenticate({Key? key, required this.showSignIn}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  void toggleView() {
    setState(() {
      widget.showSignIn = !widget.showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
    // return AuthIntroScreen();
  }
}
