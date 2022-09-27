import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData? mediaQuery;
  static double? screenWidht;
  static double? screenHeight;
  static double? blockSizeHorizontal;
  static double? blockSizeVertical;

  void init(BuildContext context) {
    mediaQuery = MediaQuery.of(context);
    screenWidht = mediaQuery!.size.width;
    screenHeight = mediaQuery!.size.height;
    blockSizeHorizontal = screenWidht! / 100;
    blockSizeVertical = screenHeight! / 100;
  }
}
