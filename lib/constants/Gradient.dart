import 'package:flutter/material.dart';
import 'package:prj1/utils/constants.dart';

Gradient bg_gradient() {
  return LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [
      0.0,
      0.8,
    ],
    colors: [
      Color(0xffdfedf6),
      ColorConstants.primaryColor,
    ],
  );
}
