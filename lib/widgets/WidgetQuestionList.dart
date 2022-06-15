import 'package:flutter/material.dart';
import 'package:prj1/utils/constants.dart';

Widget questionListwidget(String title, String subtitle) {
  return Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Colors.lightBlue.shade300,
          Colors.lightBlue.shade600,
        ],
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    child: ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      subtitle: Text(subtitle),
    ),
  );
}

BoxDecoration blueCardBox(Color color1, Color color2, Color shadowColor) {
  return BoxDecoration(
    borderRadius: new BorderRadius.all(new Radius.circular(25.0)),
    gradient: new LinearGradient(
      colors: [
        color1,
        color2,
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      tileMode: TileMode.clamp,
    ),
    boxShadow: [
      BoxShadow(
        color: shadowColor.withOpacity(0.5),
        spreadRadius: 5,
        blurRadius: 7,
        offset: Offset(0, 3), // changes position of shadow
      ),
    ],
  );
}

// Widget titleSubtitle(Strung ) {
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     crossAxisAlignment: CrossAxisAlignment.center,
//     children: [
//       Text()
//     ],
//   );
// }
