import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:prj1/utils/size_config.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prj1/screens/RecuiterSignin.dart';
import 'package:cupertino_tabbar/cupertino_tabbar.dart' as CupertinoTabBar;
import 'package:prj1/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final formKey = GlobalKey<FormState>();
  final license_formKey = GlobalKey<FormState>();
  String license_Status = "";
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController licenseKeyController = TextEditingController();
  bool hideSideButton = true;
  int cupertinoTabBarValueGetter() => cupertinoTabBarValue;
  int cupertinoTabBarValue = 0;
  String imagePath = "";
  String imageStatus = "";
  bool valuefirst = false;
  bool license_loader = false;

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int cupertinoTabBarValue = 0;
  }

  @override
  Widget build(BuildContext context) {
    double devwidth = MediaQuery.of(context).size.width;
    double devheight = MediaQuery.of(context).size.height;
    final String licenseKey = licenseKeyController.text;
    final String username = usernameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    final String mobile = mobileController.text;
    final String companyName = companyNameController.text;
    bool loader = false;

    void changeLicenseStatus() {
      FirebaseFirestore.instance
          .collection('licenseKey')
          .doc(licenseKey)
          .update({'AccountStatus': 'Created'});
    }

    FirebaseFirestore db = FirebaseFirestore.instance;
    var recruiterID = "";
    void register() async {
      setState(() {
        loader = true;
      });
      String imageName = path.basename(imagePath);
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref('/$imageName');
      File file = File(imagePath);
      FirebaseAuth auth = FirebaseAuth.instance;

      try {
        await ref.putFile(file);
        print("file uploaded successfully");
        String downloadedUrl = await ref.getDownloadURL();
        print(downloadedUrl);
        print("email will send to " + email);
        User? userCredential = auth.currentUser;
        final UserCredential user = await auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .whenComplete(
              () async => {
                await userCredential!.sendEmailVerification(),
                setState(() {
                  cupertinoTabBarValue = 0;
                  changeLicenseStatus();
                }),
                print("email sent"),
              },
            );
        setState(() {
          recruiterID = user.user!.uid;
        });
        print("RECRUITER ID");
        print(recruiterID);
        await db.collection("users").doc(user.user!.uid).set(
          {
            "email": email,
            "username": username,
            "pictureUrl": downloadedUrl,
            "mobileNumber": mobile,
            "companyName": companyName,
            "licenseKey": licenseKey,
            "q1_title": "Motivation",
            "q1_detail": "What motivates you? ",
            "a1_1": "I am hardworking",
            "a1_2": "I am smart working",
            "a1_3": "I am lazy",
            "a1_4": "I am good to work",
            "a1_5": "I am efficient",
            "q2_title": "Disappointment",
            "q2_detail": "What has disappointed you about work? ",
            "a2_1": "I am hardworking",
            "a2_2": "I am smart working",
            "a2_3": "I am lazy",
            "a2_4": "I am good to work",
            "a2_5": "I am efficient",
            "q3_title": "Co-workers",
            "q3_detail": "What irritates you about co-workers?",
            "a3_1": "I am hardworking",
            "a3_2": "I am smart working",
            "a3_3": "I am lazy",
            "a3_4": "I am good to work",
            "a3_5": "I am efficient",
            "q4_title": "Hatred for job type",
            "q4_detail": "Have you ever worked in a job that you hated?",
            "a4_1": "I am hardworking",
            "a4_2": "I am smart working",
            "a4_3": "I am lazy",
            "a4_4": "I am good to work",
            "a4_5": "I am efficient",
            "q5_title": "Sacrifice for company",
            "q5_detail":
                "Are you willing to make sacrifices for this company? ",
            "a5_1": "I am hardworking",
            "a5_2": "I am smart working",
            "a5_3": "I am lazy",
            "a5_4": "I am good to work",
            "a5_5": "I am efficient",
            "q6_title": "Skills",
            "q6_detail":
                "Do your skills match this job or another job more closely?",
            "a6_1": "I am hardworking",
            "a6_2": "I am smart working",
            "a6_3": "I am lazy",
            "a6_4": "I am good to work",
            "a6_5": "I am efficient",
            "q7_title": "Stress",
            "q7_detail": "How do you cope with stress?",
            "a7_1": "I am hardworking",
            "a7_2": "I am smart working",
            "a7_3": "I am lazy",
            "a7_4": "I am good to work",
            "a7_5": "I am efficient",
            "q8_title": "Overtime",
            "q8_detail":
                "Are you willing to work overtime? Prepare for nightshift and work on Weekends?",
            "a8_1": "I am hardworking",
            "a8_2": "I am smart working",
            "a8_3": "I am lazy",
            "a8_4": "I am good to work",
            "a8_5": "I am efficient",
            "q9_title": "Work under pressure",
            "q9_detail": "Describe your ability to work under pressure. ",
            "a9_1": "I am hardworking",
            "a9_2": "I am smart working",
            "a9_3": "I am lazy",
            "a9_4": "I am good to work",
            "a9_5": "I am efficient",
            "q10_title": "Best thing about you",
            "q10_detail":
                "What would your previous supervisor say your best point is?",
            "a10_1": "I am hardworking",
            "a10_2": "I am smart working",
            "a10_3": "I am lazy",
            "a10_4": "I am good to work",
            "a10_5": "I am efficient",
          },
        ).whenComplete(() {
          Fluttertoast.showToast(msg: "Your information has inserted")
              .whenComplete(() {
            setState(() {
              loader = false;
            });
          });
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Fluttertoast.showToast(msg: "The password provided is too weak.")
              .whenComplete(() {
            setState(() {
              loader = false;
            });
          });
        } else if (e.code == 'email-already-in-use') {
          Fluttertoast.showToast(
                  msg: "The account already exists for that email.")
              .whenComplete(() {
            setState(() {
              loader = false;
            });
          });
        }
      } catch (e) {
        print(e);
      }
    }

    // void registerQuestion() async {
    //   try {
    //     await db
    //         .collection("users")
    //         .doc(recruiterID)
    //         .collection("questionaire")
    //         .doc("questions")
    //         .set({
    //       "q1_title": "No Question 1 title defined",
    //       "q1_detail": "No Question 1 detail defined",
    //       "q2_title": "No Question 2 title defined",
    //       "q2_detail": "No Question 2 detail defined",
    //       "q3_title": "No Question 3 title defined",
    //       "q3_detail": "No Question 3 detail defined",
    //       "q4_title": "No Question 4 title defined",
    //       "q4_detail": "No Question 4 detail defined",
    //       "q5_title": "No Question 4 title defined",
    //       "q5_detail": "No Question 4 detail defined",
    //       "q6_title": "No Question 4 title defined",
    //       "q6_detail": "No Question 4 detail defined",
    //       "q7_title": "No Question 4 title defined",
    //       "q7_detail": "No Question 4 detail defined",
    //       "q8_title": "No Question 4 title defined",
    //       "q8_detail": "No Question 4 detail defined",
    //       "q9_title": "No Question 4 title defined",
    //       "q9_detail": "No Question 4 detail defined",
    //       "q10_title": "No Question 4 title defined",
    //       "q10_detail": "No Question 4 detail defined",
    //     });
    //   } catch (e) {}
    // }

    void checkLicense(docID) {
      print("Check license method");
      FirebaseFirestore.instance.collection('licenseKey').doc(docID).get().then(
        (DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            print("snapshot data");
            print(documentSnapshot.get('AccountStatus'));
            if (documentSnapshot.get('AccountStatus').toString() ==
                "Not Created")
              setState(
                () {
                  license_loader = false;
                  license_Status = "License Key approved";
                  cupertinoTabBarValue = 2;
                },
              );
            else
              setState(() {
                license_Status =
                    "An account is already registered on this License Key";
              });
          } else {
            print("Error");
            license_Status = "License Key incorrect";
            license_loader = false;
          }
        },
      );
    }

    void pickImage() async {
      final ImagePicker _picker = ImagePicker();
      final image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        imagePath = image!.path;
      });
      print(imagePath);
      if (imagePath != null) {
        setState(() {
          imageStatus = "Image selected";
        });
      } else if (imagePath == null) {
        setState(() {
          imageStatus = "Image not selected";
        });
      }
    }

    return SingleChildScrollView(
      child: Container(
        // color: Colors.blue.shade200,
        // height: devheight,
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              child: (cupertinoTabBarValue == 0)
                  ? RecruiterSignin()
                  : (cupertinoTabBarValue == 1)
                      ? Form(
                          key: license_formKey,
                          child: Column(
                            children: [
                              SizedBox(
                                height: SizeConfig.screenHeight * 0.1,
                              ),
                              Text(
                                "We hope you have purchase our license. Enter the license key and get started to signup.",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  textStyle:
                                      Theme.of(context).textTheme.headline6,
                                ),
                              ),
                              textfield1("License Key", licenseKeyController,
                                  TextInputType.text, licenseKey),
                              SizedBox(
                                height: 10,
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    license_loader = true;
                                    license_formKey.currentState?.validate();
                                    print(licenseKey);
                                    checkLicense(licenseKeyController.text);
                                  });
                                },
                                icon: Icon(
                                  Icons.lock,
                                  color: ColorConstants.white,
                                ),
                                label: Text(
                                    (license_loader)
                                        ? 'Verifying Key'
                                        : 'Enter License Key',
                                    style: TextStyle(
                                      color: ColorConstants.white,
                                    )),
                                style: ElevatedButton.styleFrom(
                                  primary: ColorConstants.primaryColor,
                                ),
                              ),
                              Text(license_Status),
                              SizedBox(
                                height: SizeConfig.screenHeight * 0.1,
                              ),
                            ],
                          ),
                        )
                      : Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Recruiter\nSign Up",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Lottie.asset(
                                      'assets/animations/SignupLottie.json',
                                      fit: BoxFit.fill,
                                      alignment: Alignment.bottomRight,
                                    ),
                                    flex: 3,
                                  ),
                                ],
                              ),
                              textfield1("Username", usernameController,
                                  TextInputType.text, username),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 10,
                                    child: textfield1(
                                        "Enter Password",
                                        passwordController,
                                        TextInputType.text,
                                        password),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          hidePass = !hidePass;
                                        });
                                        print("Eye pressed");
                                      },
                                      child: Icon(Icons.remove_red_eye),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              textfield1("Email", emailController,
                                  TextInputType.emailAddress, email),
                              SizedBox(
                                height: 10,
                              ),
                              textfield1("Mobile Number", mobileController,
                                  TextInputType.number, mobile),
                              SizedBox(
                                height: 15,
                              ),
                              textfield1("Company Name", companyNameController,
                                  TextInputType.text, companyName),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: ColorConstants.primaryColor,
                                    ),
                                    onPressed: () {
                                      pickImage();
                                    },
                                    child: Text(
                                      "Choose an image",
                                      style: TextStyle(
                                          color: ColorConstants.white),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(imageStatus),
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: Colors.black,
                                    value: this.valuefirst,
                                    onChanged: (bool? value) {
                                      setState(
                                        () {
                                          this.valuefirst = value!;
                                          print("checkbox" +
                                              valuefirst.toString());
                                        },
                                      );
                                    },
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: Text('Terms and Conditions'),
                                            content: Text(
                                                'You will have to give us access to your \n1. Camera\n2. Mic to record your voice.'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Accept Terms and Conditions",
                                        style: TextStyle(
                                            color: ColorConstants.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 8,
                                    child: Text(
                                      "Signup to continue",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: ElevatedButton(
                                        style: TextButton.styleFrom(
                                          shape: CircleBorder(),
                                          backgroundColor: Colors.blue[300],
                                          padding: EdgeInsets.all(15),
                                        ),
                                        child: (loader)
                                            ? CircularProgressIndicator(
                                                strokeWidth: 3,
                                                color: ColorConstants.white,
                                              )
                                            : Icon(
                                                Icons.chevron_right_outlined,
                                                color: ColorConstants.white,
                                              ),
                                        onPressed: () {
                                          print("checkbox" +
                                              valuefirst.toString());
                                          // setState(() {
                                          //   loader = true;
                                          //   print(loader);
                                          // });
                                          showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              title: Text('Loading'),
                                              content: Text(
                                                  'Please wait, your information is processing'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            ),
                                          );
                                          if (valuefirst) {
                                            if (formKey.currentState!
                                                .validate()) {
                                              register();
                                            }
                                            print("moizbinata");
                                            print(username);
                                            print(email);
                                            print(recruiterID);
                                            // registerQuestion();
                                          } else {
                                            setState(() {
                                              loader = false;
                                            });
                                            showDialog(
                                              context: context,
                                              builder: (_) => AlertDialog(
                                                backgroundColor:
                                                    ColorConstants.primaryColor,
                                                title: Text(
                                                  'Terms and Conditions',
                                                  style: TextStyle(
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: SizeConfig
                                                            .textMultiplier *
                                                        2,
                                                  ),
                                                ),
                                                content: Text(
                                                    'You must have to accept terms and conditions for signup.'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text(
                                                      'OK',
                                                      style: TextStyle(
                                                        color: ColorConstants
                                                            .white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                (loader) ? "Please wait" : "",
                              ),
                            ],
                          ),
                        ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: (cupertinoTabBarValue == 0)
                          ? TextButton(
                              style: TextButton.styleFrom(
                                side: BorderSide(
                                    width: 1, color: ColorConstants.white),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                              ),
                              onPressed: () {
                                setState(() {
                                  cupertinoTabBarValue = 1;
                                  // hideSideButton = !hideSideButton;
                                });
                              },
                              child: Text(
                                "Recruiter Sign Up",
                                style: TextStyle(color: ColorConstants.white),
                              ),
                            )
                          : TextButton(
                              style: TextButton.styleFrom(
                                side: BorderSide(
                                    width: 1, color: ColorConstants.white),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                              ),
                              onPressed: () {
                                setState(() {
                                  cupertinoTabBarValue = 0;
                                  // hideSideButton = !hideSideButton;
                                });
                              },
                              child: Text(
                                "Recruiter Sign In",
                                style: TextStyle(color: ColorConstants.white),
                              ),
                            )),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.1,
            )
          ],
        ),
      ),
    );
  }

  bool hidePass = true;

  Widget textfield1(lbl, controller, keyboardType, newValue) {
    return TextFormField(
      maxLength: (lbl == "Enter Password" || lbl == "Username")
          ? 10
          : (lbl == "Email")
              ? 30
              : (lbl == "Mobile Number")
                  ? 15
                  : (lbl == "License Key")
                      ? 30
                      : 20,

      obscureText: (lbl == "Enter Password") ? hidePass : false,
      onChanged: (value) {
        newValue = value;
        controller = newValue;
        print(newValue);
        print(controller);
      },

      // obscuringCharacter: '•',
      controller: controller,
      keyboardType: keyboardType,
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
        //fillColor: Colors.green
      ),
      style: new TextStyle(
        fontSize: 12,
      ),
      validator: (lbl == "Enter Password")
          ? Validators.compose([
              Validators.required('Password required'),
            ])
          : (lbl == "Username")
              ? Validators.compose([
                  Validators.required('Username Required'),
                  Validators.patternRegExp(
                      RegExp(r"^[A-Za-z]+$"), 'Only alphabets are allowed'),
                ])
              : (lbl == "Email")
                  ? Validators.compose([
                      Validators.required('Email Required'),
                      Validators.email('Invalid email address'),
                    ])
                  : (lbl == "Mobile Number")
                      ? Validators.compose([
                          Validators.required('Mobile Number required'),
                          Validators.patternRegExp(
                              RegExp(r"^[0-9]+$"), 'Only numbers are allowed'),
                        ])
                      : (lbl == "License Key")
                          ? Validators.compose([
                              Validators.required('License Key required'),
                            ])
                          : Validators.compose([
                              Validators.required('Required'),
                            ]),
    );
  }
}

Widget passwordField(lbl, controller) {
  return TextFormField(
    controller: controller,
    obscureText: true,
    obscuringCharacter: '•',
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
    keyboardType: TextInputType.emailAddress,
    style: new TextStyle(
      fontSize: 12,
      color: ColorConstants.white,
    ),
  );
}
