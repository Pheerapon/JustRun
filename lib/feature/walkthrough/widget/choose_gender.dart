import 'package:flutter/material.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'walkthrough_widget.dart';

class ChooseGender extends StatefulWidget {
  @override
  _ChooseGenderState createState() => _ChooseGenderState();
}

class _ChooseGenderState extends State<ChooseGender> {
  bool showFemale = true;
  bool showMale = false;

  @override
  Widget build(BuildContext context) {
    final height = AppWidget.getHeightScreen(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                final SharedPreferences shared =
                    await SharedPreferences.getInstance();
                setState(() {
                  showFemale = true;
                  showMale = false;
                  if (showFemale) {
                    shared.setString('gender', 'Female');
                  } else {
                    shared.remove('gender');
                  }
                });
              },
              child: Container(
                width: constraints.maxWidth * 0.45,
                height: constraints.maxHeight,
                child: WalkThroughWidget.createFigure(
                    height: height,
                    image: 'gif/female_walking.gif',
                    choose: showFemale,
                    gender: 'Female'),
              ),
            ),
            SizedBox(
              width: constraints.maxWidth * 0.1,
            ),
            GestureDetector(
              onTap: () async {
                final SharedPreferences shared =
                    await SharedPreferences.getInstance();
                setState(() {
                  showMale = true;
                  showFemale = false;
                  if (showMale) {
                    shared.setString('gender', 'Male');
                  } else {
                    shared.remove('gender');
                  }
                });
              },
              child: Container(
                width: constraints.maxWidth * 0.45,
                height: constraints.maxHeight,
                child: WalkThroughWidget.createFigure(
                    height: height,
                    image: 'gif/male_walking.gif',
                    gender: 'Male',
                    choose: showMale),
              ),
            ),
          ],
        );
      },
    );
  }
}
