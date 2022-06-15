import 'package:flutter/material.dart';

abstract class ThemeText {
  static const TextStyle progressHeader = TextStyle(
      color: Colors.black,
      fontSize: 40,
      height: 0.5,
      fontWeight: FontWeight.w600);
  static const TextStyle head1 = TextStyle(
      color: Colors.white,
      fontSize: 30,

      // height: 0.5,
      fontWeight: FontWeight.bold);
  static const TextStyle progressBody = TextStyle(
      color: Colors.white,
      fontSize: 20,
      height: 0.5,
      fontWeight: FontWeight.w400);

  static const TextStyle progressFooter = TextStyle(
      color: Colors.black,
      fontSize: 20,
      height: 0.5,
      fontWeight: FontWeight.w600);
}
