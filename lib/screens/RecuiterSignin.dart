import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:prj1/screens/Signup.dart';
import 'package:prj1/screens/recruiterhome.dart';
import 'package:prj1/utils/constants.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class RecruiterSignin extends StatefulWidget {
  const RecruiterSignin({Key? key}) : super(key: key);

  @override
  _RecruiterSigninState createState() => _RecruiterSigninState();
}

class _RecruiterSigninState extends State<RecruiterSignin> {
  final signinFormKey = GlobalKey<FormState>();

  bool valuefirst = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String loginNote = "";
  bool loader = false;
  // final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String email = "";
    String password = "";
    double devwidth = MediaQuery.of(context).size.width;
    double devheight = MediaQuery.of(context).size.height;

    void login() async {
      print("login function");
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore db = FirebaseFirestore.instance;
      final String email = emailController.text;
      final String password = passwordController.text;
      try {
        final UserCredential user = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        final DocumentSnapshot snapshot =
            await db.collection("users").doc(user.user!.uid).get();

        User firebaseUser = auth.currentUser!;
        print("User has logged in");
        print(snapshot['email']);
        print(snapshot['username']);

        if (firebaseUser.emailVerified) {
          print(user.user!.uid);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => RecruiterHome(user.user!.uid, snapshot),
            ),
          ).whenComplete(() {
            loader = false;
          });
        } else {
          setState(() {
            loader = false;
            loginNote =
                '⚠️ This email is registered but not verified !. Verification email has been sent, Please verify first by clicking on verification link !';
          });
          auth.signOut();
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          setState(() {
            loader = false;

            loginNote = '⚠️ No user found for that email.';
          });
        } else if (e.code == 'wrong-password') {
          setState(() {
            loader = false;

            loginNote = '⚠️ Wrong password provided for that user.';
          });
        }
      }
    }

    return Container(
      // height: devheight,
      color: Colors.transparent,
      child: Center(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    "Recruiter\nSign In",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Lottie.asset('assets/animations/SigninLottie.json'),
                  flex: 3,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Form(
                key: signinFormKey,
                child: Column(
                  children: [
                    textfield1("Email", emailController,
                        TextInputType.emailAddress, email),
                    SizedBox(
                      height: 15,
                    ),
                    textfield1("Password", passwordController,
                        TextInputType.text, password),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child: Text(
                            "Login to continue",
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
                                print("moiz");
                                setState(() {
                                  loader = true;
                                });
                                if (signinFormKey.currentState?.validate() ==
                                    true) {
                                  login();
                                } else {
                                  setState(() {
                                    loader = false;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
            Text(
              loginNote,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

Widget textfield1(lbl, controller, keyboardType, newValue) {
  bool hidePass = true;
  return Row(
    children: [
      Expanded(
        flex: 10,
        child: TextFormField(
          maxLength: (lbl == "Password" || lbl == "Username")
              ? 10
              : (lbl == "Email")
                  ? 30
                  : (lbl == "Mobile Number")
                      ? 15
                      : (lbl == "License Key")
                          ? 30
                          : 20,

          obscureText: (lbl == "Password") ? hidePass : false,
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
          validator: (lbl == "Password")
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
                              Validators.patternRegExp(RegExp(r"^[0-9]+$"),
                                  'Only numbers are allowed'),
                            ])
                          : (lbl == "License Key")
                              ? Validators.compose([
                                  Validators.required('License Key required'),
                                ])
                              : Validators.compose([
                                  Validators.required('Required'),
                                ]),
        ),
      ),
      // if (lbl == "Password")
      //   Expanded(
      //       child: IconButton(
      //     onPressed: () {

      //       print("Eye pressed");
      //     },
      //     icon: Icon(Icons.remove_red_eye),
      //   )),
    ],
  );
}
