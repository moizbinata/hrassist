// import 'package:file_picker/file_picker.dart';
import 'dart:async';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prj1/constants/Gradient.dart';
import 'package:prj1/constants/VideoConstants.dart';
import 'package:prj1/screens/RedirectToQuestions.dart';
import 'package:prj1/screens/SignInUp.dart';
import 'package:prj1/screens/UploadScreen.dart';
import 'package:prj1/screens/WelcomeUser.dart';
import 'package:prj1/screens/views/CameraPage.dart';
import 'package:prj1/screens/views/voice_text.dart';
import 'package:prj1/utils/bluePainter.dart';
import 'package:prj1/utils/constants.dart';
import 'package:prj1/utils/size_config.dart';
import 'package:prj1/utils/speechController.dart';
import 'package:prj1/widgets/WidgetQuestionList.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'controllers/google_sign_in.dart';

class QuestionList extends StatefulWidget {
  @override
  _QuestionListState createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  var snapshotUsers;
  late String uid;
  late String q_id;
  GetStorage box = GetStorage();
  SpeechController speechController = SpeechController();
  int numOfEmptyAns = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // qID = widget.q_id;

    getQuestions();
  }

  String totalConf = "";
  String totalPer = "";
  void getQuestions() async {
    uid = box.read('u_id').toString();
    q_id = box.read('q_id').toString();
    final DocumentSnapshot snapshotUser =
        await db.collection("interviewee_details").doc(uid).get();
    if (snapshotUser.exists) {
      snapshotUsers = snapshotUser;
      print("moizata");
      print(snapshotUser['email']);
      setState(() {
        totalConf = snapshotUsers['totalConf'];
        totalPer = snapshotUsers['totalPer'];
      });
      print(totalPer);
      numOfEmptyAns = 0;
      for (int i = 1; i < 11; i++) {
        if (snapshotUsers['a' + i.toString()].toString() == "")
          setState(() {
            numOfEmptyAns++;
          });
      }
      print("numOfEmptyAns: " + numOfEmptyAns.toString());
    } else {
      print("moizata");
      print("none");
    }
  }

  final user = FirebaseAuth.instance.currentUser!;
  bool loader = false;
  late File file;
  String imagePath = "";
  FirebaseFirestore db = FirebaseFirestore.instance;
  String currUser = FirebaseAuth.instance.currentUser!.uid;
  dynamic _pickImageError;
  VideoPlayerController? _controller;
  bool isVideo = false;
  VideoPlayerController? _toBeDisposed;
  final ImagePicker _picker = ImagePicker();
  XFile? xfile;
  String videoPath = "";
  String videoStatus = "";

  Future<void> _disposeVideoController() async {
    if (_toBeDisposed != null) {
      await _toBeDisposed!.dispose();
    }
    _toBeDisposed = _controller;
    _controller = null;
  }

  Future<void> _playVideo(XFile? file) async {
    if (file != null && mounted) {
      await _disposeVideoController();
      late VideoPlayerController controller;
      if (kIsWeb) {
        controller = VideoPlayerController.network(file.path);
      } else {
        controller = VideoPlayerController.file(File(file.path));
      }
      _controller = controller;

      final double volume = kIsWeb ? 0.0 : 1.0;
      await controller.setVolume(volume);
      await controller.initialize();
      await controller.setLooping(true);
      await controller.play();
      setState(() {});
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    String videoStatus = "";
    FirebaseAuth auth = FirebaseAuth.instance;

    void pickImage() async {
      final ImagePicker _picker = ImagePicker();
      final image = await _picker.pickVideo(
          source: ImageSource.camera, maxDuration: const Duration(seconds: 10));
      setState(() {
        imagePath = image!.path;
      });
      print(imagePath);
      if (imagePath.isNotEmpty) {
        setState(() {
          videoStatus = "Image selected";
        });
      } else if (imagePath.isEmpty) {
        setState(() {
          videoStatus = "Image not selected";
        });
      }
    }

    Future<bool> _onImageButtonPressed(ImageSource source, int i,
        {BuildContext? context, bool isMultiImage = false}) async {
      // if (_controller != null) {
      //   await _controller!.setVolume(0.0);
      // }
      if (isVideo) {
        xfile = await _picker.pickVideo(
            source: source, maxDuration: const Duration(seconds: 10));
        // await _playVideo(xfile);
        print("XFILE PATH IS" + xfile!.path);

        WidgetsFlutterBinding.ensureInitialized();
        await Firebase.initializeApp();
        file = File(xfile!.path);

        print("Video File " + i.toString() + " has stored in array");
        return true;
      } else {
        return false;
      }
    }

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
        ).whenComplete(() {
          setState(() {
            loader = false;
          });
        });
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

    return Scaffold(
      backgroundColor: ColorConstants.primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => RedirectToQuestions()),
                (route) => false,
              );
            },
            icon: Icon(Icons.chevron_left_outlined)),
        title: Text(
          "Interview Questions",
          style: TextStyle(
            fontSize: SizeConfig.textMultiplier * 3,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.googleLogout().whenComplete(
                    () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignInUp()),
                    ),
                  );
            },
            child: Text(
              "Logout ",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: CustomPaint(
          painter: BluePainter2(),
          child: Container(
            child: Column(
              children: [
                (loader)
                    ? Container(
                        width: deviceWidth,
                        height: deviceHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Recording"),
                            CircularProgressIndicator(
                              color: ColorConstants.white,
                            ),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    loader = false;
                                    // speechController.isListening.value = false;
                                  });
                                },
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: ColorConstants.white),
                                )),
                          ],
                        ))
                    : Column(
                        children: [
                          (numOfEmptyAns != 0)
                              ? SizedBox()
                              : (totalConf == "" && totalPer == "")
                                  ? Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: TextButton.icon(
                                            onPressed: () {
                                              print("dsf");
                                              createAndSaveResult();
                                            },
                                            icon: Icon(Icons.file_copy),
                                            label: Text("Create Result")),
                                      ),
                                    )
                                  : Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: TextButton.icon(
                                            onPressed: () {
                                              showResult();
                                            },
                                            icon: Icon(Icons.file_copy),
                                            label: Text("Show Result")),
                                      ),
                                    ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(q_id)
                                  // .collection('questionaire')
                                  // .doc('questions')
                                  .get(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text("Something went wrong");
                                }

                                if (snapshot.hasData &&
                                    !snapshot.data!.exists) {
                                  return Text("Document does not exist");
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  Map<String, dynamic> data = snapshot.data!
                                      .data() as Map<String, dynamic>;
                                  return Container(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        for (int i = 1; i < 11; i++)
                                          Container(
                                            margin: EdgeInsets.only(bottom: 10),
                                            decoration: blueCardBox(
                                                ColorConstants.primaryColor,
                                                Colors.blueGrey,
                                                ColorConstants.grey2),
                                            child: ListTile(
                                              // key: ValueKey<Object>(redrawObject),
                                              title: Text(
                                                  '${data['q' + i.toString() + '_title']}'),
                                              subtitle: Text(
                                                  '${data['q' + i.toString() + '_detail']}'),
                                              trailing: (snapshotUsers['a' +
                                                                  i.toString()]
                                                              .toString() ==
                                                          "" &&
                                                      snapshotUsers['conf' +
                                                                  i.toString()]
                                                              .toString() ==
                                                          "")
                                                  ? IconButton(
                                                      icon: Icon(
                                                          Icons.play_arrow),
                                                      onPressed: () async {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        VoiceToText(
                                                                          qNo:
                                                                              i,
                                                                        )));
                                                        // SpeechController
                                                        //     speechController =
                                                        //     SpeechController();

                                                        // setState(() {
                                                        //   loader = true;

                                                        //   // speechController
                                                        //   //     .isListening
                                                        //   //     .value = true;
                                                        //   // isListening
                                                        // });
                                                        // speechController
                                                        //     .listen();
                                                        // isVideo = true;
                                                        // await _onImageButtonPressed(
                                                        //     ImageSource.camera,
                                                        //     i);
                                                        // uploadVideos(i, file);
                                                      },
                                                    )
                                                  : Text("Already Uploaded"),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                }

                                return Center(
                                  child: CircularProgressIndicator(
                                    color: ColorConstants.white,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void resultCreatedAndToast() {
    print("resultcreated");
    Fluttertoast.showToast(msg: "Result has been created");
    getQuestions();
  }

  void createAndSaveResult() async {
    print("moiz");
    List percentages = [];
    List confidences = [];
    double totalPercent = 0.0;
    double totalConfidence = 0.0;
    for (int i = 1; i < 11; i++) {
      totalPercent += double.parse(snapshotUsers['percent' + i.toString()]);
      totalConfidence += double.parse(snapshotUsers['conf' + i.toString()]);
    }
    print("total perc" + totalPercent.toString());
    print("total conf" + totalConfidence.toString());
    await db.collection("interviewee_details").doc(currUser).update(
      {
        "totalConf": (totalConfidence / 10).toStringAsFixed(1),
        "totalPer": (totalPercent / 10).toString(),
      },
    ).whenComplete(
      () => resultCreatedAndToast(),
    );
  }

  void showResult() {
    getQuestions();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Your Result for current interview'),
        content: Text(
            'You got $totalConf % in Confidence level, and $totalPer % in Answers of the given questions.\nWe wish you a good luck for your Interview,\nHope you succeeded'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
