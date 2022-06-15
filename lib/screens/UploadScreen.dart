// import 'dart:html';
// import 'dart:io';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prj1/constants/Gradient.dart';
import 'package:prj1/screens/Questionlist.dart';
import 'package:prj1/utils/constants.dart';

class UploadScreen extends StatefulWidget {
  final File file;
  final int i;

  UploadScreen(
    this.file,
    this.i,
  );
  // const UploadScreen({Key? key}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  @override
  void initState() {
    super.initState();
    uploadVideos(widget.i);
  }

  Future<void> uploadVideos(int i) async {
    String name = DateTime.now().toString();

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child(name + currUser + "Video"); //string interpolation

    try {
      // await ref.putFile(file);
      await ref.putFile(widget.file);

      print("FILE UPLOADEDD SUCCESFILLY");
      String downloadedUrl = await ref.getDownloadURL();
      print("DOWNLOAD URL IS" + downloadedUrl);
      // User? userCredential = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection("interviewee_details")
          .doc(currUser)
          .update(
        {
          "q" + i.toString() + "_video": "$downloadedUrl",
        },
      );
      Fluttertoast.showToast(msg: "Your video interviewee has uploaded");

      Navigator.pop(context);
    } catch (e) {
      print("NOt uploadedddddddd");
      print(e.toString());
    }
    return Future.delayed(
        const Duration(seconds: 2), () => print('Large Latte'));
  }

  String currUser = FirebaseAuth.instance.currentUser!.uid;
  // FirebaseFirestore db = FirebaseFirestore.instance;
  // File? file;

  @override
  Widget build(BuildContext context) {
    double devwidth = MediaQuery.of(context).size.width;
    double devheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: devwidth,
        decoration: BoxDecoration(
          gradient: bg_gradient(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: ColorConstants.darkBlue,
            )
          ],
        ),
      ),
    );
  }
}
