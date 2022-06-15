import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:prj1/screens/Home.dart';
import 'package:prj1/styles/style.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation heartbeatAnimation;
  // bool _visible = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    heartbeatAnimation =
        Tween<double>(begin: 200.0, end: 100.0).animate(controller);
    controller.forward();
    Future.delayed(Duration(seconds: 3)).then((value) {
      Navigator.pushReplacement(
        context,
        PageTransition(
          duration: Duration(milliseconds: 1000),
          type: PageTransitionType.rightToLeftWithFade,
          child: Home(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    // AnimatedOpacity(
    //   opacity: _visible ? 1.0 : 0.0,
    //   duration: const Duration(milliseconds: 2900),
    return AnimatedBuilder(
      animation: heartbeatAnimation,
      builder: (context, widget) {
        return Scaffold(
          body: Container(
            width: deviceWidth,
            height: deviceHeight,
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(1, -1),
                end: const Alignment(1, 0.1),
                colors: [
                  Color(0xFFFFFFFF), //#FFFFFF
                  Color(0xff8ec5ed),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/ic_launcher.png',
                  width: heartbeatAnimation.value,
                  height: heartbeatAnimation.value,
                ),
                Row(),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Future Is Now",
                  style: ThemeText.head1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
