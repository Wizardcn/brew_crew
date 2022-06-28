import 'package:brew_crew/screens/authenticate/authenticate.dart';
import 'package:flutter/material.dart';

class AuthIntroScreen extends StatefulWidget {
  const AuthIntroScreen({Key? key}) : super(key: key);

  @override
  State<AuthIntroScreen> createState() => _AuthIntroScreenState();
}

class _AuthIntroScreenState extends State<AuthIntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            Authenticate(showSignIn: true),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.pink[300], // background
                  onPrimary: Colors.white, // foreground
                ),
                child: const Text('Sign In'),
              ),
              const SizedBox(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            Authenticate(showSignIn: false),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.pink[300], // background
                  onPrimary: Colors.white, // foreground
                ),
                child: const Text('Register'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
