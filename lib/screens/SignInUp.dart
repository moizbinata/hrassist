import 'package:cupertino_tabbar/cupertino_tabbar.dart' as CupertinoTabBar;

import 'package:flutter/material.dart';
import 'package:prj1/screens/Home.dart';
import 'package:prj1/screens/Login.dart';
import 'package:prj1/screens/RecuiterSignin.dart';
import 'package:prj1/screens/Signup.dart';
import 'package:prj1/utils/bluePainter.dart';
import 'package:prj1/utils/size_config.dart';

class SignInUp extends StatefulWidget {
  const SignInUp({Key? key}) : super(key: key);

  @override
  _SignInUpState createState() => _SignInUpState();
}

class _SignInUpState extends State<SignInUp> {
  int cupertinoTabBarValueGetter() => cupertinoTabBarValue;
  int cupertinoTabBarValue = 1;
  @override
  Widget build(BuildContext context) {
    double devwidth = MediaQuery.of(context).size.width;
    double devheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: CustomPaint(
        painter: BluePainter2(),
        child: Container(
          width: devwidth,
          height: devheight,
          padding: EdgeInsets.only(
            top: SizeConfig.screenHeight * 0.1,
          ),
          child: SingleChildScrollView(
            child: Container(
              // height: devheight,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // width: devwidth,
                    child: CupertinoTabBar.CupertinoTabBar(
                      const Color(0xFF3c4245),
                      const Color(0xFF719192),
                      [
                        const Text(
                          "Recruiter",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18.75,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Text(
                          "Interviewee",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18.75,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      cupertinoTabBarValueGetter,
                      (int index) {
                        setState(() {
                          cupertinoTabBarValue = index;
                        });
                      },
                      duration: Duration(milliseconds: 100),
                    ),
                  ),
                  Container(
                    child: (cupertinoTabBarValue == 0) ? Signup() : Login(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
