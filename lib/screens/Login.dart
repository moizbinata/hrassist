import 'package:flutter/cupertino.dart';
import 'package:cupertino_tabbar/cupertino_tabbar.dart' as CupertinoTabBar;
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:prj1/screens/Home.dart';
import 'package:prj1/screens/Home3.dart';
import 'package:prj1/screens/controllers/google_sign_in.dart';
import 'package:prj1/utils/bluePainter.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loader = true;
  bool _slowAnimations = false;
  int cupertinoTabBarValueGetter() => cupertinoTabBarValue;
  int cupertinoTabBarValue = 3;
  final TextEditingController q_Title = TextEditingController();
  final TextEditingController q_Details = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double devwidth = MediaQuery.of(context).size.width;
    double devheight = MediaQuery.of(context).size.height;
    return Container(
      // height: devheight,
      // color: Colors.blue.shade200,
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset('assets/animations/intervieweeLottie.json'),
            Text(
              "Sign In",
              style: TextStyle(
                fontSize: 36,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Are you interviewee / applicant. No need to registration, Just sign in with google, and get started",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: (loader)
                  ? SignInButton(
                      Buttons.Google,
                      onPressed: () {
                        setState(() {
                          loader = !loader;
                        });
                        final provider = Provider.of<GoogleSignInProvider>(
                            context,
                            listen: false);
                        provider.googleLogin().whenComplete(
                          () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Home3()),
                            );
                          },
                        );
                        // setState(() {
                        //   loader = !loader;
                        // });
                      },
                      text: (loader) ? 'Signin with Google' : 'Loading',
                    )
                  : CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
