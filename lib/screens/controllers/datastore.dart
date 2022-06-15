import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:prj1/screens/SignInUp.dart';

class Datastore extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error connecting");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return SignInUp();
        }
        return Text("Not Connecting");
      },
    );
  }
}
