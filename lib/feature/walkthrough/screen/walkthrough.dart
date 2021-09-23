import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';

import '../bloc/slider/bloc_slider.dart';
import '../widget/option_login.dart';
import '../widget/walkthrough_widget.dart';

class WalkThrough extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = AppWidget.getWidthScreen(context);
    final height = AppWidget.getHeightScreen(context);
    final SliderBloc sliderBloc = BlocProvider.of<SliderBloc>(context);
    return Scaffold(
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.only(top: 60, left: 32),
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  'images/logoDetail@3x.png',
                  fit: BoxFit.cover,
                  width: width / 2,
                )),
            Container(
              height: height / 203 * 95,
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Image.asset(
                'images/walkthrough@3x.png',
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 16),
              child: OptionLogin(),
            )
          ],
        ),
      ),
    );
  }
}
