import 'package:flutter/material.dart';

//Primary
Color ultramarineBlue = const Color(0xFF4B66EA);
Color magnolia = const Color(0xFFEDF0FD);

//Secondary
Color caribbeanGreen = const Color(0xFF00C48C);
Color redSalsa = const Color(0xFFEB5757);
Color sandyBrown = const Color(0xFFF2994A);
Color azure = const Color(0xFF0084F4);
Color maizeCrayola = const Color(0xFFFFCF5C);

//Grey shade
Color grey1100 = const Color(0xFF1F2933);
Color grey1000 = const Color(0xFF323F4B);
Color grey900 = const Color(0xFF3E4C59);
Color grey800 = const Color(0xFF52606D);
Color grey700 = const Color(0xFF616E7C);
Color grey600 = const Color(0xFF7B8794);
Color grey500 = const Color(0xFF9AA5B1);
Color grey400 = const Color(0xFFCBD2D9);
Color grey300 = const Color(0xFFE4E7EB);
Color grey200 = const Color(0xFFF5F7FA);
Color white = const Color(0xFFFFFFFF);

//Custom color
Color textGenderUnSelected = const Color(0xFF433246);
Color btnAppleID = const Color(0xFF1A051D);
Color gray = const Color(0xFF828282);
Color black = const Color(0xFF000000);
Color black2 = const Color(0xFF252525);
Color textMoney = const Color(0xFF0F4C81);
Color indicator = const Color(0xFF6D5F6F);
Color bgChart = const Color(0xFFF7F8F9);
Color btnGoogle = const Color(0xFFFF647C);
Color colorGenderSelected = const Color(0xFFFFA26B);
Color colorGender = const Color(0xFFF0F0F0);
Color grey04 = const Color(0xFFC1DDDA);
Color primary = const Color(0xFFEA7260);

extension CustomColorTheme on ThemeData {
  //background
  Color get color1 =>
      brightness == Brightness.light ? azure.withOpacity(0.05) : grey900;
  Color get color2 => brightness == Brightness.light ? bgChart : grey1000;
  //text
  Color get color3 => brightness == Brightness.light ? btnAppleID : grey200;
  Color get color4 => brightness == Brightness.light ? grey700 : grey500;
  Color get color5 => brightness == Brightness.light ? grey800 : grey400;
  Color get color6 => brightness == Brightness.light ? grey900 : grey300;
  Color get color7 => brightness == Brightness.light ? grey1000 : grey200;
  Color get color8 => brightness == Brightness.light ? grey1100 : white;
  Color get color9 => brightness == Brightness.light ? btnAppleID : white;
  Color get color10 => brightness == Brightness.light ? black2 : white;
  Color get color11 => brightness == Brightness.light ? textMoney : white;
  Color get color12 => brightness == Brightness.light ? indicator : grey500;
  Color get color13 => brightness == Brightness.light ? white : grey1100;
  Color get color14 => brightness == Brightness.light ? grey900 : grey600;
  Color get color15 => brightness == Brightness.light ? grey200 : grey1000;
  Color get color16 => brightness == Brightness.light ? grey300 : grey1000;
  Color get color17 => brightness == Brightness.light ? grey600 : white;
  //google map
  RadialGradient get colorGoogle => brightness == Brightness.light
      ? const RadialGradient(
          colors: [
            Color.fromRGBO(255, 255, 255, 0.0001),
            Color.fromRGBO(255, 255, 255, 0.2),
            Color.fromRGBO(255, 255, 255, 0.3),
            Color.fromRGBO(255, 255, 255, 0.4),
            Color.fromRGBO(255, 255, 255, 1),
          ],
        )
      : const RadialGradient(
          colors: [
            Color.fromRGBO(31, 41, 51, 0.0001),
            Color.fromRGBO(31, 41, 51, 0.2),
            Color.fromRGBO(31, 41, 51, 0.3),
            Color.fromRGBO(31, 41, 51, 0.4),
            Color.fromRGBO(31, 41, 51, 1),
          ],
        );
}
