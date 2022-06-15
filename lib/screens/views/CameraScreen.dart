import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prj1/screens/views/VideoView.dart';

late File file;
List<CameraDescription> cameras = [];

class CameraScreen extends StatefulWidget {
  CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  late Future<void> cameraValue;
  bool isRecoring = false;
  bool flash = false;
  bool iscamerafront = true;
  double transform = 0;
  String currUser = "";
  FirebaseFirestore db = FirebaseFirestore.instance;

  String q_id = "";
  GetStorage box = GetStorage();

  Future<void> uploadVideos(int i, File file2) async {
    String name = DateTime.now().toString();

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child(name + currUser + "Video"); //string interpolation

    try {
      // await ref.putFile(file);
      await ref.putFile(file2);

      print("FILE UPLOADEDD SUCCESFILLY");
      String downloadedUrl = await ref.getDownloadURL();
      print("DOWNLOAD URL IS" + downloadedUrl);
      // User? userCredential = FirebaseAuth.instance.currentUser;
      await db.collection("interviewee_details").doc(currUser).update(
        {
          "q" + i.toString() + "_video": "$downloadedUrl",
          "questionaireID": q_id,
        },
      );
      Fluttertoast.showToast(msg: "Your video interview has uploaded");
      Navigator.popAndPushNamed(context, '/QuestionList');
      Navigator.pop(context);
    } catch (e) {
      print("NOt uploadedddddddd");
      print(e.toString());
    }
    return Future.delayed(
        const Duration(seconds: 2), () => print('Large Latte'));
  }

  @override
  void initState() {
    super.initState();
    // currUser = FirebaseAuth.instance.currentUser!.uid;
    // q_id = box.read('q_id').toString();

    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    cameraValue = _cameraController.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
              future: cameraValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: CameraPreview(_cameraController));
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
          Positioned(
            bottom: 0.0,
            child: Container(
              color: Colors.black,
              padding: EdgeInsets.only(top: 5, bottom: 5),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          icon: Icon(
                            flash ? Icons.flash_on : Icons.flash_off,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () {
                            setState(() {
                              flash = !flash;
                            });
                            flash
                                ? _cameraController
                                    .setFlashMode(FlashMode.torch)
                                : _cameraController.setFlashMode(FlashMode.off);
                          }),
                      GestureDetector(
                        onLongPress: () async {
                          await _cameraController.startVideoRecording();
                          setState(() {
                            isRecoring = true;
                          });
                        },
                        onLongPressUp: () async {
                          XFile videopath =
                              await _cameraController.stopVideoRecording();
                          // File file = File(videopath.path);
                          print("moiz" + videopath.path.toString());
                          setState(() {
                            isRecoring = false;
                          });
                          file = File(videopath.path);
                          uploadVideos(2, file);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => VideoViewPage(
                                        path: videopath.path,
                                      )));
                        },
                        onTap: () {
                          Fluttertoast.showToast(
                              msg: 'Camera not allowed, Do long-press');
                          // if (!isRecoring) takePhoto(context);
                        },
                        child: isRecoring
                            ? Icon(
                                Icons.radio_button_on,
                                color: Colors.red,
                                size: 80,
                              )
                            : Icon(
                                Icons.panorama_fish_eye,
                                color: Colors.white,
                                size: 70,
                              ),
                      ),
                      IconButton(
                          icon: Transform.rotate(
                            angle: transform,
                            child: Icon(
                              Icons.flip_camera_ios,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              iscamerafront = !iscamerafront;
                              transform = transform + pi;
                            });
                            int cameraPos = iscamerafront ? 0 : 1;
                            _cameraController = CameraController(
                                cameras[cameraPos], ResolutionPreset.high);
                            cameraValue = _cameraController.initialize();
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Hold for Video, tap for photo",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // void takePhoto(BuildContext context) async {
  //   XFile file = await _cameraController.takePicture();
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (builder) => CameraViewPage(
  //                 path: file.path,
  //               )));
  // }
}
