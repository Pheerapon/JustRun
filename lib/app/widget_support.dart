import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';

import 'opacity_clicked.dart';

class AppWidget {
  static double getHeightScreen(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getWidthScreen(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static Future<void> showDialogCustom({BuildContext context}) async {
    showDialog<dynamic>(
      context: context,
      barrierDismissible: false,
      barrierColor: black.withOpacity(0.1),
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: const CupertinoActivityIndicator(
              animating: true,
            ));
      },
    );
  }

  static Widget createSimpleAppBar(
      {BuildContext context,
      bool hasPop = true,
      bool hasBackground = false,
      String title,
      Function onTap}) {
    return AppBar(
      elevation: 0,
      backgroundColor: hasBackground ? Theme.of(context).color15 : null,
      leading: OpacityClicked(
        child: GestureDetector(
          onTap: () {
            if (hasPop) {
              Navigator.of(context).pop();
            }
          },
          child: Icon(
            Icons.keyboard_arrow_left,
            size: 24,
            color: Theme.of(context).color9,
          ),
        ),
      ),
      centerTitle: true,
      title: title == null
          ? null
          : Text(
              title,
              style: AppWidget.simpleTextFieldStyle(
                  fontSize: 16, height: 18, color: black),
            ),
      actions: [
        onTap != null
            ? Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: [
                    OpacityClicked(
                      child: GestureDetector(
                        onTap: onTap,
                        child: Text(
                          'SKIP',
                          style: AppWidget.boldTextFieldStyle(
                              fontSize: 12, height: 18, color: ultramarineBlue),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : const SizedBox()
      ],
    );
  }

  static TextStyle simpleTextFieldStyle(
      {Color color,
      double fontSize,
      double height,
      FontStyle fontStyle,
      FontWeight fontWeight,
      String fontFamily = 'SFProDisplay',
      TextDecoration textDecoration}) {
    return TextStyle(
        color: color ?? white,
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.w400,
        decoration: textDecoration ?? TextDecoration.none,
        height: height / fontSize,
        fontStyle: fontStyle ?? FontStyle.normal,
        fontFamily: fontFamily);
  }

  static TextStyle boldTextFieldStyle(
      {Color color,
      double fontSize,
      double height,
      FontStyle fontStyle,
      FontWeight fontWeight,
      String fontFamily = 'SFProDisplay',
      TextDecoration textDecoration}) {
    return TextStyle(
        color: color ?? white,
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.w700,
        decoration: textDecoration ?? TextDecoration.none,
        height: height / fontSize,
        fontStyle: fontStyle ?? FontStyle.normal,
        fontFamily: fontFamily);
  }

  static Widget typeButtonStartAction(
      {double fontSize,
      double height,
      double vertical,
      double horizontal,
      Function onPressed,
      Color bgColor,
      double miniSizeHorizontal = double.infinity,
      Color textColor,
      String input,
      FontWeight fontWeight,
      double borderRadius = 16,
      String icon}) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
            vertical: vertical ?? 13, horizontal: horizontal ?? 0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        backgroundColor: bgColor ?? ultramarineBlue,
        minimumSize: Size(miniSizeHorizontal, 0),
        primary: white,
      ),
      onPressed: onPressed,
      child: icon == null
          ? Text(
              input,
              textAlign: TextAlign.center,
              style: AppWidget.simpleTextFieldStyle(
                  fontSize: fontSize ?? 16,
                  color: textColor ?? white,
                  fontWeight: fontWeight ?? FontWeight.w500,
                  height: height ?? 24),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: [
                    SizedBox(
                        width: constraints.maxWidth * 0.3,
                        child: Image.asset(
                          icon,
                          width: 16,
                          height: 16,
                        )),
                    Text(
                      input,
                      textAlign: TextAlign.center,
                      style: AppWidget.simpleTextFieldStyle(
                          fontSize: fontSize ?? 16,
                          color: textColor ?? white,
                          fontWeight: fontWeight ?? FontWeight.w500,
                          height: height ?? 24),
                    ),
                  ],
                );
              },
            ),
    );
  }

  static SnackBar customSnackBar({@required String content, Color color}) {
    return SnackBar(
      backgroundColor: color ?? btnGoogle,
      content: Text(
        content,
        textAlign: TextAlign.center,
        style: AppWidget.simpleTextFieldStyle(
            color: white, fontSize: 14, height: 21),
      ),
    );
  }

  static Widget divider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Divider(
        thickness: 1,
        color: Theme.of(context).color16,
      ),
    );
  }
}
