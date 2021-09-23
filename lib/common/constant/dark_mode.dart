import 'package:flutter/material.dart';
import 'package:flutter_habit_run/app/widget_support.dart';

import 'colors.dart';

ThemeData lightMode = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.light,
  backgroundColor: white,
  scaffoldBackgroundColor: white,
  bottomNavigationBarTheme:
      BottomNavigationBarThemeData(backgroundColor: white),
  appBarTheme: AppBarTheme(
    brightness: Brightness.light,
    color: white,
  ),
  textTheme: TextTheme(
    headline1:
        AppWidget.boldTextFieldStyle(fontSize: 32, height: 42, color: grey1100),
    headline2: AppWidget.boldTextFieldStyle(
        fontSize: 20, height: 30, color: textGenderUnSelected),
    headline3:
        AppWidget.boldTextFieldStyle(fontSize: 18, height: 28, color: gray),
    headline4: AppWidget.simpleTextFieldStyle(
        color: white, fontSize: 16, height: 24, fontWeight: FontWeight.w600),
    headline6: AppWidget.simpleTextFieldStyle(
        color: ultramarineBlue, fontSize: 12, height: 18),
    bodyText1: AppWidget.simpleTextFieldStyle(
        fontSize: 16, height: 24, color: grey700),
    bodyText2: AppWidget.simpleTextFieldStyle(
        fontSize: 14, height: 21, color: btnAppleID),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
ThemeData darkMode = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.dark,
  backgroundColor: grey1100,
  scaffoldBackgroundColor: grey1100,
  bottomNavigationBarTheme:
      BottomNavigationBarThemeData(backgroundColor: grey1000),
  appBarTheme: AppBarTheme(
    brightness: Brightness.dark,
    color: grey1100,
  ),
  textTheme: TextTheme(
    headline1:
        AppWidget.boldTextFieldStyle(fontSize: 32, height: 42, color: white),
    headline2: AppWidget.boldTextFieldStyle(
        fontSize: 20, height: 30, color: textGenderUnSelected),
    headline3:
        AppWidget.boldTextFieldStyle(fontSize: 18, height: 28, color: white),
    headline4: AppWidget.simpleTextFieldStyle(
        color: white, fontSize: 16, height: 24, fontWeight: FontWeight.w600),
    headline6: AppWidget.simpleTextFieldStyle(
        color: ultramarineBlue, fontSize: 12, height: 18),
    bodyText1: AppWidget.simpleTextFieldStyle(
        fontSize: 16, height: 24, color: grey500),
    bodyText2:
        AppWidget.simpleTextFieldStyle(fontSize: 14, height: 21, color: white),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
