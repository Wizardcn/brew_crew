import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/screens/authenticate/authenticate.dart';
// import 'package:brew_crew/screens/authenticate/forgot.dart';
import 'package:brew_crew/screens/wrapper.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // anything inside this Wrapper widget can access the data provided by this stream
    return StreamProvider<AppUser?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const Wrapper(),
        // initialRoute: '/home',
        routes: {
          // '/': (context) => const Loading(),
          // '/home': (context) => const Wrapper(),
          '/sign_in': (context) => Authenticate(showSignIn: true),
          '/register': (context) => Authenticate(showSignIn: false),
          // '/password_reset': (context) => const Forgot(),
        },
      ),
    );
  }
}
