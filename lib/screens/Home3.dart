import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prj1/screens/Login.dart';
import 'package:prj1/screens/SignInUp.dart';
import 'package:prj1/screens/WelcomeUser.dart';
import 'package:prj1/utils/constants.dart';
import 'package:provider/provider.dart';

import 'controllers/google_sign_in.dart';

class Home3 extends StatefulWidget {
  const Home3({Key? key}) : super(key: key);

  @override
  _Home3State createState() => _Home3State();
}

class _Home3State extends State<Home3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return WelcomeUser();
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return SignInUp();
          } else {
            print(snapshot.error);
            return SignInUp();
          }
        },
      ),
    );
  }
}
