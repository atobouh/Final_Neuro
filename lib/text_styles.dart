import 'package:flutter/material.dart';
import 'package:ff_t/utils/colors.dart';
import 'package:ff_t/utils/constants.dart';

// FONT CHANGE: Removed GoogleFonts and now using the default TextStyle,
// which will inherit the OpenDyslexic font from the app's theme.
class AppTextStyles {
  static TextStyle headline1 = const TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w800,
    color: lightText,
    letterSpacing: -0.5,
  );

  static TextStyle headline2 = const TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: lightText,
  );

  static TextStyle headline3 = const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: lightText,
  );

  static TextStyle headline4 = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: lightText,
  );

  static TextStyle bodyText1 = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular weight for body
    color: lightText,
    height: 1.5,
  );

  static TextStyle bodyText2 = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: mediumText,
    height: 1.4,
  );

  static TextStyle buttonText = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: white,
  );

  static TextStyle linkText = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: accentBlue,
    decoration: TextDecoration.underline,
  );

  static TextStyle hintText = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: mediumText,
  );
}
