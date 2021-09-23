import 'package:flutter/material.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/route/routes.dart';
import 'package:flutter_habit_run/feature/home/screen/home.dart';

class GetReward extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AppWidget.typeButtonStartAction(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.homeScreen, (route) => false,
                arguments: const HomeScreen());
          },
          input: 'Run to get point',
          bgColor: ultramarineBlue,
          textColor: white),
    );
  }
}
