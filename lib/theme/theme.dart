import 'package:flutter/material.dart';

import './constants.dart';

abstract class AppTheme {
  static ThemeData get lightTheme => light();
  static ThemeData get darkTheme => dark();
}

ThemeData light() {
  return ThemeData(
    unselectedWidgetColor: supportLightSeparator,
    brightness: Brightness.light,
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        height: 38 / 32,
        color: labelLightPrimary,
      ),
      bodyText2: TextStyle(
        fontSize: 16,
        height: 20 / 16,
        fontWeight: FontWeight.w400,
        color: labelLightPrimary,
      ),
      subtitle2: TextStyle(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w400,
        color: labelLightPrimary,
      ),
      button: TextStyle(
        fontSize: 14,
        height: 24 / 14,
        fontWeight: FontWeight.w500,
        color: labelLightPrimary,
      ),
      headline2: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        height: 32 / 20,
        color: labelLightPrimary,
      ),
    ),
  );
}

ThemeData dark() {
  return ThemeData(
    unselectedWidgetColor: supportLightSeparator,
    brightness: Brightness.dark,
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        height: 38 / 32,
        color: labelLightPrimary,
      ),
      bodyText2: TextStyle(
        fontSize: 16,
        height: 20 / 16,
        fontWeight: FontWeight.w400,
        color: labelLightPrimary,
      ),
      subtitle2: TextStyle(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w400,
        color: labelLightPrimary,
      ),
      button: TextStyle(
        fontSize: 14,
        height: 24 / 14,
        fontWeight: FontWeight.w400,
        color: labelLightPrimary,
      ),
      headline2: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        height: 32 / 20,
        color: labelLightPrimary,
      ),
    ),
  );
}
