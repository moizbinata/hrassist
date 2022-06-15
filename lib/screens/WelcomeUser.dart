import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prj1/screens/Questionlist.dart';
import 'package:prj1/screens/RecuiterSignin.dart';
import 'package:prj1/screens/RedirectToQuestions.dart';
import 'package:prj1/screens/SignInUp.dart';
import 'package:prj1/screens/Signup.dart';
import 'package:prj1/screens/recruiterhome.dart';
import 'package:prj1/utils/bluePainter.dart';
import 'package:prj1/utils/constants.dart';
import 'package:prj1/utils/size_config.dart';
import 'package:provider/provider.dart';
import 'controllers/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class WelcomeUser extends StatefulWidget {
  const WelcomeUser({Key? key}) : super(key: key);

  @override
  _WelcomeUserState createState() => _WelcomeUserState();
}

class _WelcomeUserState extends State<WelcomeUser> {
  GetStorage box = GetStorage();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController questionID = TextEditingController();
  late File file;
  String imagePath = "";
  final formKey = GlobalKey<FormState>();
  String imageStatus = "";
  bool loader = false;
  String warning = "";
  String pdfPath = "";
  String pdfStatus = "";
  String currUid = FirebaseAuth.instance.currentUser!.uid;
  int a = 3;
  @override
  initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Future<void> getData() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    final DocumentSnapshot snapshot =
        await db.collection("interviewee_details").doc(currUid).get();
    // print(snapshot['username']);
    if (snapshot.exists) {
      setState(() {
        a = 1;
      });
    } else {
      setState(() {
        a = 2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    File pdfFile;
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    final user = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore db = FirebaseFirestore.instance;

    void getQuestion() async {
      setState(() {
        loader = true;
      });
      String q_id = questionID.text;
      try {
        FirebaseFirestore db = FirebaseFirestore.instance;

        final DocumentSnapshot snapshot =
            await db.collection("users").doc(q_id).get();
        if (snapshot.exists) {
          // final DocumentSnapshot snapshot_user =
          //     await db.collection("interviewee_details").doc(user.uid).get();
          FirebaseFirestore.instance
              .collection('interviewee_details')
              .doc(currUid)
              .update({'questionaireID': q_id});
          box.write('q_id', q_id);
          box.write('u_id', user.uid);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RedirectToQuestions(),
            ),
          );
          setState(() {
            loader = false;
            warning = "";
          });
        } else {
          setState(() {
            warning = "Incorrect Questionaire ID or connection error";
            loader = false;
          });
        }
      } on FirebaseAuthException catch (e) {
        print(e.code);
        setState(() {
          loader = false;

          warning = "Incorrect UID or connection error";
        });
      }
    }

    Future<void> pickResume() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        pdfFile = File(result.files.single.path!);
        pdfPath = pdfFile.path;
        print("pdf selected: " + pdfPath);
        setState(() {
          pdfStatus = "PDF selected";
        });
      } else {
        setState(() {
          pdfStatus = "PDF not selected";
        });
        print("PDF not selected");
      }
    }

    void pickImage() async {
      final ImagePicker _picker = ImagePicker();
      final image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        imagePath = image!.path;
      });
      print(imagePath);
      if (imagePath != "") {
        setState(() {
          imageStatus = "Image selected";
        });
      } else if (imagePath == "") {
        setState(() {
          imageStatus = "Image not selected";
        });
      }
    }

    void register() async {
      String pdfName = path.basename(pdfPath);
      String imageName = path.basename(imagePath);
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref(pdfName);
      firebase_storage.Reference ref2 =
          firebase_storage.FirebaseStorage.instance.ref(imageName);
      File file = File(pdfPath);
      File imgFile = File(imagePath);
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore db = FirebaseFirestore.instance;

      try {
        await ref.putFile(file);
        await ref2.putFile(imgFile);
        print("file uploaded successfully");
        String downloadedUrl = await ref.getDownloadURL();
        String downloadedImgUrl = await ref2.getDownloadURL();
        print("pdf and image URL");
        print(downloadedUrl);
        print(downloadedImgUrl);

        User? userCredential = auth.currentUser;

        await db.collection("interviewee_details").doc(currUid).set(
          {
            "username": user.displayName,
            "mobileNumber": phoneNumber.text,
            "email": user.email,
            "resumeUrl": downloadedUrl,
            "imageUrl": downloadedImgUrl,
            "questionaireID": "not defined",
            "a1": "",
            "a2": "",
            "a3": "",
            "a4": "",
            "a5": "",
            "a6": "",
            "a7": "",
            "a8": "",
            "a9": "",
            "a10": "",
            "conf1": "",
            "conf2": "",
            "conf3": "",
            "conf4": "",
            "conf5": "",
            "conf6": "",
            "conf7": "",
            "conf8": "",
            "conf9": "",
            "conf10": "",
            "totalConf": "",
            "percent1": "",
            "percent2": "",
            "percent3": "",
            "percent4": "",
            "percent5": "",
            "percent6": "",
            "percent7": "",
            "percent8": "",
            "percent9": "",
            "percent10": "",
            "totalPer": "",
          },
        ).whenComplete(() {
          setState(() {
            loader = false;
            a = 1;
          });
        });
        Fluttertoast.showToast(msg: "Your information has inserted");
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: Container(
          color: Color(0xff82beed),
          child: CustomPaint(
            painter: CircularBackgroundPainter(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: deviceWidth,
              height: deviceHeight,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.05,
                    ),
                    Center(
                      child: Container(
                        height: SizeConfig.screenHeight * 0.3,
                        child: Lottie.asset(
                          'assets/animations/welcomeUserLottie.json',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        "Welcome",
                        style: TextStyle(color: Colors.white, fontSize: 34),
                      ),
                      trailing: TextButton(
                        onPressed: () {
                          final provider = Provider.of<GoogleSignInProvider>(
                              context,
                              listen: false);
                          provider.googleLogout().whenComplete(
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignInUp()),
                                ),
                              );
                        },
                        child: Text(
                          "Logout",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Image(
                        image: NetworkImage(user.photoURL!),
                      ),
                      title: Text(
                        "${user.displayName![0].toUpperCase()}${user.displayName!.substring(1)}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        user.email!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.content_copy),
                      label: Text(
                        "COPY YOUR USER ID: " + user.uid,
                        style: TextStyle(fontSize: 10),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(0),
                        primary: Colors.white,
                        // backgroundColor: Colors.blue.shade200,
                        shadowColor: Colors.transparent,
                      ),
                      // color: Colors.blue,
                      onPressed: () {
                        var data = user.uid;
                        print(user.uid);
                        Clipboard.setData(
                          ClipboardData(
                            text: user.uid.toString(),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    if (a == 1)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: ColorConstants.primaryColor),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: ColorConstants.primaryColor,
                                title: Text(
                                  'Welcome to Online Video Interview',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.normal),
                                ),
                                content: TextField(
                                  cursorColor: ColorConstants.white,
                                  controller: questionID,
                                  textInputAction: TextInputAction.go,
                                  decoration: InputDecoration(
                                    hintText:
                                        "Enter the Interview ID given by HRR",
                                  ),
                                ),
                                actions: <Widget>[
                                  new ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: ColorConstants.primaryColor,
                                    ),
                                    child: (!loader)
                                        ? Text(
                                            'Submit',
                                            style: TextStyle(
                                                color: ColorConstants.white),
                                          )
                                        : CircularProgressIndicator(
                                            color: ColorConstants.white),
                                    onPressed: () {
                                      setState(() {
                                        loader = true;
                                        a = 1;
                                      });
                                      Navigator.pop(context);
                                      getQuestion();
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        },
                        child: new Text(
                          "Go for Interview",
                          style: TextStyle(color: ColorConstants.white),
                        ),
                      )
                    else if (a == 2 || a == 3)
                      Column(
                        children: [
                          Text(
                            "Please provide the required information to get started",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          // ElevatedButton(
                          //   onPressed: () {
                          //     getData();
                          //   },
                          //   child: Text("Get DAta"),
                          // ),
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                textfield1('Phone number', phoneNumber,
                                    TextInputType.number, phoneNumber),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: ColorConstants.primaryColor),
                                      onPressed: () {
                                        pickResume();
                                      },
                                      child: Text(
                                        "Select your resume",
                                        style: TextStyle(
                                            color: ColorConstants.white),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      pdfStatus,
                                      style: TextStyle(
                                        color: ColorConstants.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: ColorConstants.primaryColor),
                                      onPressed: () {
                                        pickImage();
                                      },
                                      child: Text(
                                        "Select your Image",
                                        style: TextStyle(
                                            color: ColorConstants.white),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      imageStatus,
                                      style: TextStyle(
                                        color: ColorConstants.white,
                                      ),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: ColorConstants.primaryColor),
                                  onPressed: () {
                                    formKey.currentState?.validate();
                                    (imageStatus == "Image selected")
                                        ? setState(() {
                                            loader = true;
                                            register();
                                          })
                                        : print("Image not selected");
                                  },
                                  child: (loader)
                                      ? CircularProgressIndicator()
                                      : Text(
                                          "Submit",
                                          style: TextStyle(
                                              color: ColorConstants.white),
                                        ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    Text(warning),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
