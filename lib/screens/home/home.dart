import 'package:brew_crew/screens/home/audio_player.dart';
import 'package:brew_crew/screens/home/brew_list.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot?>.value(
      value: DatabaseService().brews,
      initialData: null,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: const Text('Brew Crew'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.person),
              label: const Text('logout'),
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent, // background
                onPrimary: Colors.white, // foreground
                elevation: 0.0,
              ),
              onPressed: () async {
                await _auth.signOut();
              },
            )
          ],
        ),
        body: const audioScreen(),
      ),
    );
  }
}
