import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SizeConfig {
  static double _screenWidth = 0.0;
  static double _screenHeight = 0.0;
  static double _blockSizeHorizontal = 0;
  static double _blockSizeVertical = 0;

  static double textMultiplier = 0.0;
  static double imageSizeMultiplier = 0.0;
  static double heightMultiplier = 0.0;
  static double screenWidth = 0.0;
  static double screenHeight = 0.0;

  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
    } else {
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
    }
    _blockSizeHorizontal = _screenWidth / 100;
    _blockSizeVertical = _screenHeight / 100;

    screenWidth = _screenWidth;
    screenHeight = _screenHeight;
    textMultiplier = _blockSizeVertical;
    imageSizeMultiplier = _blockSizeHorizontal;
    heightMultiplier = _blockSizeVertical;

    // print("Image Size\n");
    // print(imageSizeMultiplier);

    // print("Text Size\n");
    // print(textMultiplier);

    // print("Height Size\n");
    // print(heightMultiplier);
  }
}
