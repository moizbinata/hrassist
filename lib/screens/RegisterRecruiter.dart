import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:prj1/screens/SignInUp.dart';

class RegisterRecruiter extends StatefulWidget {
  final String username;
  final String email;
  final String password;
  final String mobile;
  final String companyName;
  final String imagePath;
  RegisterRecruiter(
    this.username,
    this.email,
    this.password,
    this.mobile,
    this.companyName,
    this.imagePath,
  );
  // const RegisterRecruiter({Key? key}) : super(key: key);
  @override
  _RegisterRecruiterState createState() => _RegisterRecruiterState();
}

class _RegisterRecruiterState extends State<RegisterRecruiter> {
  @override
  void initState() {
    super.initState();
    print("next screen 1");
    print(widget.imagePath);
    print(widget.username);
    register(widget.username, widget.email, widget.password, widget.mobile,
        widget.companyName, widget.imagePath);
  }

  void register(String username, String email, String password, String mobile,
      String companyName, String imagePath) async {
    print("next screen 2");
    print(imagePath);
    String imageName = path.basename(imagePath);
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref('/$imageName'); //string interpolation
    File file = File(imagePath);
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;

    try {
      await ref.putFile(file);
      print("file uploaded successfully");
      String downloadedUrl = await ref.getDownloadURL();
      print(downloadedUrl);

      User? userCredential = auth.currentUser;
      final UserCredential user = await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .whenComplete(
            () async => {
              await userCredential!.sendEmailVerification(),
              Fluttertoast.showToast(
                  msg: "Email verification has sent to your email"),
              print("email sent"),
            },
          );
      await db.collection("users").doc(user.user!.uid).set(
        {
          "email": email,
          "username": username,
          "pictureUrl": downloadedUrl,
          "mobileNumber": mobile,
          "companyName": companyName,
          "q1_title": "No Question 1 title defined",
          "q1_detail": "No Question 1 detail defined",
          "q2_title": "No Question 2 title defined",
          "q2_detail": "No Question 2 detail defined",
          "q3_title": "No Question 3 title defined",
          "q3_detail": "No Question 3 detail defined",
          "q4_title": "No Question 4 title defined",
          "q4_detail": "No Question 4 detail defined",
        },
      ).whenComplete(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignInUp(),
          ),
        );
      });
      Fluttertoast.showToast(msg: "Your information has inserted");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: "The account already exists for that email.");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double devwidth = MediaQuery.of(context).size.width;
    double devheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: devwidth,
        height: devheight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [CircularProgressIndicator()],
        ),
      ),
    );
  }
}
