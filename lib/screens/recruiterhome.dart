import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:prj1/screens/IntervieweeDetails.dart';
import 'package:prj1/screens/SignInUp.dart';
import 'package:prj1/utils/bluePainter.dart';
import 'package:prj1/utils/constants.dart';
import 'package:prj1/utils/size_config.dart';
import 'package:prj1/widgets/WidgetQuestionList.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class RecruiterHome extends StatefulWidget {
  final String uid;
  final DocumentSnapshot snapshot;

  RecruiterHome(this.uid, this.snapshot);
  @override
  _RecruiterHomeState createState() => _RecruiterHomeState();
}

class _RecruiterHomeState extends State<RecruiterHome> {
  final questionformKey = GlobalKey<FormState>();

  TextEditingController _qTitleController = new TextEditingController();

  TextEditingController _qDetailController = new TextEditingController();
  TextEditingController ans1Controller = new TextEditingController();
  TextEditingController ans2Controller = new TextEditingController();
  TextEditingController ans3Controller = new TextEditingController();
  TextEditingController ans4Controller = new TextEditingController();
  TextEditingController ans5Controller = new TextEditingController();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(
      () {
        _selectedIndex = index;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String _qTitle = "Not defined";

    String _qDetail = "Not defined";
    String ans1 = "";
    String ans2 = "";
    String ans3 = "";
    String ans4 = "";
    String ans5 = "";
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorConstants.primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: SizedBox(
          width: 0,
        ),
        title: Text(
          "Recruiter Account",
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.textMultiplier * 2.8,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              FirebaseAuth auth = FirebaseAuth.instance;
              auth.signOut().whenComplete(() => {
                    // Fluttertoast.showToast(
                    //   msg: "Logout succesfully",
                    // ),
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignInUp()),
                    ),
                  });
            },
            child: Text(
              "Logout",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: CustomPaint(
        painter: BluePainter(),
        child: Container(
          height: deviceHeight,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: deviceWidth,
              // height: deviceHeight,
              // color: Colors.blue.shade200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: CircleAvatar(
                          maxRadius: 30,
                          backgroundImage:
                              NetworkImage(widget.snapshot['pictureUrl']),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          alignment: Alignment.topRight,
                          height: SizeConfig.screenHeight * 0.2,
                          width: SizeConfig.screenHeight * 0.2,
                          child: Lottie.asset(
                            'assets/animations/SignupLottie.json',
                            // fit: BoxFit.fill,
                            // alignment: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Hi " + widget.snapshot['username'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                      "Click and Copy the questions id and give it to interviewee"),
                  ElevatedButton.icon(
                    icon: Icon(Icons.copy_all),
                    label: Text(
                      widget.snapshot.id,
                      style: TextStyle(fontSize: 10),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(0),
                      primary: Colors.white,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    // color: Colors.blue,
                    onPressed: () {
                      var data = widget.snapshot.id;
                      Clipboard.setData(
                        ClipboardData(
                          text: widget.snapshot.id.toString(),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: new BoxDecoration(
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(10.0)),
                        gradient: new LinearGradient(
                            colors: [
                              ColorConstants.primaryColor,
                              ColorConstants.secondaryColor,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            tileMode: TileMode.clamp)),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        onSurface: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  // UserInformation()),
                                  IntervieweeDetails(widget.snapshot.id)),
                        );
                      },
                      child: Text("Interviewee Details",
                          style: TextStyle(color: ColorConstants.white)),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Questionaire For Interviewee",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  FutureBuilder<DocumentSnapshot>(
                    future: users
                        .doc(widget.uid)
                        // .collection('questionaire')
                        // .doc('questions')
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text("Something went wrong");
                      }

                      if (snapshot.hasData && !snapshot.data!.exists) {
                        return Text("Document does not exist");
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        // return Text("Full Name: ${data['q1_title']} ");

                        return Container(
                          child: Column(
                            children: [
                              for (int i = 1; i < 10; i++)
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  decoration: new BoxDecoration(
                                      borderRadius: new BorderRadius.all(
                                          new Radius.circular(10.0)),
                                      gradient: new LinearGradient(
                                          colors: [
                                            ColorConstants.primaryColor,
                                            ColorConstants.secondaryColor,
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          tileMode: TileMode.clamp)),
                                  child: ListTile(
                                    title: Text(
                                        '${data['q' + i.toString() + '_title']}'),
                                    subtitle: Text(
                                        '${data['q' + i.toString() + '_detail']}'),
                                    trailing: IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Form(
                                                key: questionformKey,
                                                child: AlertDialog(
                                                  insetPadding: EdgeInsets.zero,
                                                  titlePadding: EdgeInsets.zero,
                                                  buttonPadding:
                                                      EdgeInsets.zero,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  actionsPadding:
                                                      EdgeInsets.zero,
                                                  content:
                                                      SingleChildScrollView(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      decoration:
                                                          new BoxDecoration(
                                                        borderRadius:
                                                            new BorderRadius
                                                                .all(new Radius
                                                                    .circular(
                                                                10.0)),
                                                        gradient: new LinearGradient(
                                                            colors: [
                                                              ColorConstants
                                                                  .primaryColor,
                                                              ColorConstants
                                                                  .secondaryColor,
                                                            ],
                                                            begin: Alignment
                                                                .centerLeft,
                                                            end: Alignment
                                                                .centerRight,
                                                            tileMode:
                                                                TileMode.clamp),
                                                      ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                              'Enter new question title:'),
                                                          TextFormField(
                                                            maxLength: 40,
                                                            onChanged: (value) {
                                                              _qTitle = value;
                                                              // _qTitleController
                                                              //     .text = _qTitle;
                                                              // print(_qTitle);
                                                              // print(
                                                              //     _qTitleController);
                                                            },
                                                            controller:
                                                                _qTitleController,
                                                            decoration:
                                                                new InputDecoration(
                                                              labelText:
                                                                  'Question Title',
                                                              labelStyle: TextStyle(
                                                                  color:
                                                                      ColorConstants
                                                                          .white),
                                                              fillColor:
                                                                  Colors.white,
                                                              enabledBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: ColorConstants
                                                                        .white),
                                                              ),
                                                              focusedBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: ColorConstants
                                                                        .white),
                                                              ),
                                                              border:
                                                                  UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: ColorConstants
                                                                        .white),
                                                              ),
                                                            ),
                                                            style:
                                                                new TextStyle(
                                                              fontSize: 12,
                                                            ),
                                                            validator:
                                                                Validators
                                                                    .compose([
                                                              Validators.required(
                                                                  'Required'),
                                                              // Validators.patternRegExp(
                                                              //     RegExp(
                                                              //         r"^[A-Za-z]+$"),
                                                              //     'Only alphabets are allowed'),
                                                            ]),
                                                          ),
                                                          TextFormField(
                                                            maxLength: 40,
                                                            onChanged: (value) {
                                                              _qDetail = value;
                                                            },
                                                            controller:
                                                                _qDetailController,
                                                            decoration:
                                                                new InputDecoration(
                                                              labelText:
                                                                  'Question Detail',
                                                              labelStyle: TextStyle(
                                                                  color:
                                                                      ColorConstants
                                                                          .white),
                                                              fillColor:
                                                                  Colors.white,
                                                              enabledBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: ColorConstants
                                                                        .white),
                                                              ),
                                                              focusedBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: ColorConstants
                                                                        .white),
                                                              ),
                                                              border:
                                                                  UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: ColorConstants
                                                                        .white),
                                                              ),
                                                            ),
                                                            style:
                                                                new TextStyle(
                                                              fontSize: 12,
                                                            ),
                                                            validator:
                                                                Validators
                                                                    .compose([
                                                              Validators.required(
                                                                  'Required'),
                                                            ]),
                                                          ),
                                                          TextFormField(
                                                            maxLength: 40,
                                                            onChanged: (value) {
                                                              ans1 = value;
                                                            },
                                                            controller:
                                                                ans1Controller,
                                                            decoration:
                                                                new InputDecoration(
                                                              labelText:
                                                                  'Expert Answer 1',
                                                              labelStyle: TextStyle(
                                                                  color:
                                                                      ColorConstants
                                                                          .white),
                                                              fillColor:
                                                                  Colors.white,
                                                              enabledBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: ColorConstants
                                                                        .white),
                                                              ),
                                                              focusedBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: ColorConstants
                                                                        .white),
                                                              ),
                                                              border:
                                                                  UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: ColorConstants
                                                                        .white),
                                                              ),
                                                            ),
                                                            style:
                                                                new TextStyle(
                                                              fontSize: 12,
                                                            ),
                                                            validator:
                                                                Validators
                                                                    .compose([
                                                              Validators.required(
                                                                  'Required'),
                                                            ]),
                                                          ),
                                                          TextFormField(
                                                            maxLength: 40,
                                                            onChanged: (value) {
                                                              ans2 = value;
                                                            },
                                                            controller:
                                                                ans2Controller,
                                                            decoration:
                                                                new InputDecoration(
                                                              labelText:
                                                                  'Expert Answer 2',
                                                              labelStyle: TextStyle(
                                                                  color:
                                                                      ColorConstants
                                                                          .white),
                                                              fillColor:
                                                                  Colors.white,
                                                              enabledBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: ColorConstants
                                                                        .white),
                                                              ),
                                                              focusedBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: ColorConstants
                                                                        .white),
                                                              ),
                                                              border:
                                                                  UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: ColorConstants
                                                                        .white),
                                                              ),
                                                            ),
                                                            style:
                                                                new TextStyle(
                                                              fontSize: 12,
                                                            ),
                                                            validator:
                                                                Validators
                                                                    .compose([
                                                              Validators.required(
                                                                  'Required'),
                                                            ]),
                                                          ),
                                                          TextFormField(
                                                            maxLength: 40,
                                                            onChanged: (value) {
                                                              ans3 = value;
                                                            },
                                                            controller:
                                                                ans3Controller,
                                                            decoration:
                                                                new InputDecoration(
                                                              labelText:
                                                                  'Expert Answer 3',
                                                              labelStyle: TextStyle(
                                                                  color:
                                                                      ColorConstants
                                                                          .white),
                                                              fillColor:
                                                                  Colors.white,
                                                              enabledBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: ColorConstants
                                                                        .white),
                                                              ),
                                                              focusedBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: ColorConstants
                                                                        .white),
                                                              ),
                                                              border:
                                                                  UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: ColorConstants
                                                                        .white),
                                                              ),
                                                            ),
                                                            style:
                                                                new TextStyle(
                                                              fontSize: 12,
                                                            ),
                                                            validator:
                                                                Validators
                                                                    .compose([
                                                              Validators.required(
                                                                  'Required'),
                                                            ]),
                                                          ),
                                                          TextFormField(
                                                            maxLength: 40,
                                                            onChanged: (value) {
                                                              ans4 = value;
                                                            },
                                                            controller:
                                                                ans4Controller,
                                                            decoration:
                                                                new InputDecoration(
                                                              labelText:
                                                                  'Expert Answer 4',
                                                              labelStyle: TextStyle(
                                                                  color:
                                                                      ColorConstants
                                                                          .white),
                                                              fillColor:
                                                                  Colors.white,
                                                              enabledBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: ColorConstants
                                                                        .white),
                                                              ),
                                                              focusedBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: ColorConstants
                                                                        .white),
                                                              ),
                                                              border:
                                                                  UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: ColorConstants
                                                                        .white),
                                                              ),
                                                            ),
                                                            style:
                                                                new TextStyle(
                                                              fontSize: 12,
                                                            ),
                                                            validator:
                                                                Validators
                                                                    .compose([
                                                              Validators.required(
                                                                  'Required'),
                                                            ]),
                                                          ),
                                                          TextFormField(
                                                            maxLength: 40,
                                                            onChanged: (value) {
                                                              ans5 = value;
                                                            },
                                                            controller:
                                                                ans5Controller,
                                                            decoration:
                                                                new InputDecoration(
                                                              labelText:
                                                                  'Expert Answer 5',
                                                              labelStyle: TextStyle(
                                                                  color:
                                                                      ColorConstants
                                                                          .white),
                                                              fillColor:
                                                                  Colors.white,
                                                              enabledBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: ColorConstants
                                                                        .white),
                                                              ),
                                                              focusedBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: ColorConstants
                                                                        .white),
                                                              ),
                                                              border:
                                                                  UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: ColorConstants
                                                                        .white),
                                                              ),
                                                            ),
                                                            style:
                                                                new TextStyle(
                                                              fontSize: 12,
                                                            ),
                                                            validator:
                                                                Validators
                                                                    .compose([
                                                              Validators.required(
                                                                  'Required'),
                                                            ]),
                                                          ),
                                                          TextButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  questionformKey
                                                                      .currentState
                                                                      ?.validate();
                                                                });
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "users")
                                                                    .doc(widget
                                                                        .uid)
                                                                    .update({
                                                                  'q' +
                                                                      i.toString() +
                                                                      '_title': _qTitle,
                                                                  'q' +
                                                                      i.toString() +
                                                                      '_detail': _qDetail,
                                                                  'a' +
                                                                          i
                                                                              .toString() +
                                                                          '_1':
                                                                      ans1Controller
                                                                          .text
                                                                          .toString(),
                                                                  'a' +
                                                                          i
                                                                              .toString() +
                                                                          '_2':
                                                                      ans2Controller
                                                                          .text
                                                                          .toString(),
                                                                  'a' +
                                                                          i
                                                                              .toString() +
                                                                          '_3':
                                                                      ans3Controller
                                                                          .text
                                                                          .toString(),
                                                                  'a' +
                                                                          i
                                                                              .toString() +
                                                                          '_4':
                                                                      ans4Controller
                                                                          .text
                                                                          .toString(),
                                                                  'a' +
                                                                          i
                                                                              .toString() +
                                                                          '_5':
                                                                      ans5Controller
                                                                          .text
                                                                          .toString(),
                                                                }).whenComplete(
                                                                        () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  _qDetailController
                                                                      .clear();
                                                                  _qTitleController
                                                                      .clear();
                                                                });
                                                              },
                                                              child: Text(
                                                                  "Submit"))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                    ),
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
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: CircleAvatar(
          radius: 60,
          backgroundImage: NetworkImage(widget.snapshot['pictureUrl']),
        ),
        onPressed: () {
          showBarModalBottomSheet(
            topControl: CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(widget.snapshot['pictureUrl']),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            context: context,
            backgroundColor: ColorConstants.secondaryColor,
            enableDrag: true,
            builder: (context) => Container(
              padding: EdgeInsets.all(10),
              color: ColorConstants.secondaryColor,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Account Information",
                      style:
                          TextStyle(color: ColorConstants.white, fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    questionListwidget("Username", widget.snapshot['username']),
                    SizedBox(
                      height: 10,
                    ),
                    questionListwidget("Email", widget.snapshot['email']),
                    SizedBox(
                      height: 10,
                    ),
                    questionListwidget(
                        "Company name", widget.snapshot['companyName']),
                    SizedBox(
                      height: 10,
                    ),
                    questionListwidget(
                        "Mobile Number", widget.snapshot['mobileNumber']),
                    SizedBox(
                      height: 10,
                    ),
                    questionListwidget(
                        "License Key", widget.snapshot['licenseKey']),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget textfield2(lbl, _qTitle, _qTitleController) {
  return TextFormField(
    maxLength: 40,
    onChanged: (value) {
      _qTitle = value;
      _qTitleController.text = _qTitle;
      print(_qTitle);
      print(_qTitleController);
    },
    controller: _qTitleController,
    decoration: new InputDecoration(
      labelText: lbl,
      labelStyle: TextStyle(color: ColorConstants.white),
      fillColor: Colors.white,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: ColorConstants.white),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: ColorConstants.white),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: ColorConstants.white),
      ),
    ),
    style: new TextStyle(
      fontSize: 12,
    ),
    validator: Validators.compose([
      Validators.required('Required'),
      Validators.patternRegExp(
          RegExp(r"^[A-Za-z]+$"), 'Only alphabets are allowed'),
    ]),
  );
}
