import 'package:brew_crew/services/auth.dart';
import 'package:flutter/material.dart';

class Forgot extends StatefulWidget {
  const Forgot({Key? key}) : super(key: key);
  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  // Explicit
  final AuthService _auth = AuthService();
  final formKey = GlobalKey<FormState>();
  String emailString = "";

  // Method
  Widget content() {
    return Center(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            emailText(),
          ],
        ),
      ),
    );
  }

  Widget emailText() {
    return Container(
      width: 250.0,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          icon: Icon(
            Icons.email,
            size: 36.0,
            color: Colors.blue.shade700,
          ),
          labelText: "Email : ",
          labelStyle: TextStyle(
            color: Colors.blue.shade700,
          ),
        ),
        onChanged: (String? value) {
          setState(() {
            emailString = value.toString().trim();
          });
        },
      ),
    );
  }

  @override
  Widget backButton() {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: Icon(
        Icons.navigate_before,
        size: 36.0,
        color: Colors.blue.shade700,
      ),
    );
  }

  Widget showTitle() {
    return const ListTile(
      leading: Icon(
        Icons.email,
        size: 48.0,
        color: Colors.green,
      ),
      title: Text(
        "Success",
        style: TextStyle(
          color: Colors.green,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget okButton() {
    return TextButton(
        onPressed: () async {
          try {
            await _auth.sendPasswordResetEmail(emailString);
          } catch (err) {
            print(err.toString());
          }
          if (!mounted) return;
          Navigator.pop(context);
          Navigator.pop(context);
        },
        child: const Text("OK"));
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: showTitle(),
            content: const Text("Please check your email"),
            actions: [okButton()],
          );
        });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [Colors.white, Colors.brown.shade800],
              radius: 0.8,
            ),
          ),
          child: Stack(children: [
            backButton(),
            content(),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade700,
        child: const Text('submit'),
        onPressed: () {
          myAlert();
        },
      ),
    );
  }
}
