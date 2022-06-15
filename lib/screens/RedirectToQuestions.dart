import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:prj1/screens/Questionlist.dart';
import 'package:prj1/screens/WelcomeUser.dart';
import 'package:prj1/utils/bluePainter.dart';
import 'package:prj1/utils/constants.dart';
import 'package:prj1/utils/size_config.dart';

class RedirectToQuestions extends StatelessWidget {
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/redirectToQues.json',
                fit: BoxFit.fill,
                alignment: Alignment.bottomRight,
              ),
              Text(
                "Continue to interview",
                style: TextStyle(fontSize: SizeConfig.textMultiplier * 2.4),
              ),
              SizedBox(
                width: SizeConfig.screenWidth * 0.5,
                child: ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: StadiumBorder(
                        side: BorderSide(
                      color: ColorConstants.white,
                      width: 3,
                    )),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            // AnswerList(),
                            QuestionList(),
                        // CameraScreen(),
                      ),
                    );
                  },
                  child: Text("Start",
                      style: TextStyle(color: ColorConstants.white)),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            // AnswerList(),
                            WelcomeUser(),
                        // CameraScreen(),
                      ),
                    );
                  },
                  child: Text("Back",
                      style: TextStyle(color: ColorConstants.white))),
            ],
          ),
        ),
      ),
    );
  }
}
