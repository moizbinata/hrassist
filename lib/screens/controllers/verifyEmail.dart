import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:prj1/screens/SignInUp.dart';
import 'package:prj1/screens/recruiterhome.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final auth = FirebaseAuth.instance;
  late User user;
  late Timer timer;
  @override
  void initState() {
    user = auth.currentUser!;
    user.sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("An Email has been send to ${user.email} please verify"),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser!;
    user.reload();
    if (user.emailVerified) {
      timer.cancel();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignInUp()),
      );
    }
  }

  void sendVerificationEmail() async {
    User user = await FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification();
    // Fluttertoast.showToast(msg: "Email verification has sent to your email");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => SignInUp()),
        (Route<dynamic> route) => false);
  }
}
