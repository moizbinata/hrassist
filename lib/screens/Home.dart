import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:prj1/screens/RecuiterSignin.dart';
import 'package:prj1/screens/SignInUp.dart';
import 'package:prj1/screens/controllers/datastore.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:flutter/cupertino.dart';
import 'package:prj1/screens/views/CameraPage.dart';
import 'package:prj1/screens/views/CameraScreen.dart';
import 'package:prj1/utils/bluePainter.dart';
import 'package:prj1/utils/constants.dart';
import 'package:prj1/utils/size_config.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   backgroundColor: ColorConstants.primaryColor,
      //   leading: Text(""),
      //   actions: [
      //     ElevatedButton.icon(
      //       onPressed: () {},
      //       icon: Icon(Icons.admin_panel_settings),
      //       label: Text("Admin"),
      //     ),
      //   ],
      // ),
      body: Container(
        width: deviceWidth,
        // height: deviceHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.blue.shade100,
            ],
          ),
        ),
        child: CustomPaint(
          painter: CurvePainter(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset('assets/animations/hr_animation1.json'),
                Text(
                  "Assistant for your recruitment process",
                  style: TextStyle(
                      color: ColorConstants.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Text(
                        "Get Started",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: ColorConstants.primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: Colors.blue[300],
                          padding: EdgeInsets.all(15),
                        ),
                        onPressed: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => CameraPage()));
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  alignment: Alignment.bottomCenter,
                                  curve: Curves.easeInOut,
                                  duration: Duration(milliseconds: 1000),
                                  reverseDuration: Duration(milliseconds: 1000),
                                  type: PageTransitionType.rightToLeftJoined,
                                  child: SignInUp(),
                                  childCurrent: this));
                        },
                        child: Icon(
                          Icons.chevron_right_outlined,
                          size: 30,
                          color: ColorConstants.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
