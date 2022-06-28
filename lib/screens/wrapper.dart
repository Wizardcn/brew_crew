import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/screens/home/home.dart';
import 'package:brew_crew/screens/authenticate/auth_intro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);

    // return either Home or Authenticate widget
    if (user == null) {
      // return const Authenticate();
      return const AuthIntroScreen();
    } else {
      return Home();
    }
  }
}
