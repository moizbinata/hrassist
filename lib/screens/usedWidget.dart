import 'package:flutter/material.dart';

Widget post() {
  return Container(
    child: Text("post"),
  );
}

Widget expandedItems() {
  return Expanded(
    child: GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      children: [],
    ),
  );
}

Widget boxButton() {
  return GestureDetector(
    onTap: () {},
    child: Container(
      padding: EdgeInsets.all(6),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(blurRadius: 4, color: Colors.blue.shade300, spreadRadius: 3)
        ],
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Color(0xFF6e8ff0),
            Color(0xFF00CCFF),
          ],
        ),
      ),
      child: Column(
        children: [
          Align(
              alignment: Alignment.topRight,
              child: Icon(
                Icons.account_circle_outlined,
                color: Color(0xFF6e8ff0),
                size: 50,
              )),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "Profile Information",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
