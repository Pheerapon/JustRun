import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/model/goal_model.dart';
import 'package:flutter_habit_run/feature/home/bloc/save_goal/bloc_save_goal.dart';

class ColumnChart extends StatefulWidget {
  const ColumnChart({this.height, this.title});
  final double height;
  final String title;
  @override
  _ColumnChartState createState() => _ColumnChartState();
}

class _ColumnChartState extends State<ColumnChart> {
  GoalModel goalModel;
  double height = 0;
  Color calcHeight(double height) {
    if (height < 60) {
      return btnGoogle;
    } else if (height >= 60 && height < 100) {
      return maizeCrayola;
    } else {
      return azure;
    }
  }

  @override
  void initState() {
    Future<dynamic>.delayed(const Duration(seconds: 1)).whenComplete(() {
      if (mounted) {
        setState(() {
          height = widget.height;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 100,
                width: 24,
                decoration: BoxDecoration(
                    color: Theme.of(context).color1,
                    borderRadius: BorderRadius.circular(4)),
              ),
              BlocBuilder<SaveGoalBloc, SaveGoalState>(
                builder: (context, state) {
                  if (state is SaveGoalSuccess) {
                    goalModel = state.goalModel;
                  }
                  return AnimatedContainer(
                    duration: const Duration(seconds: 2),
                    height: height /
                        ((goalModel == null || goalModel.step <= 0)
                            ? 1500
                            : goalModel.step) *
                        100,
                    width: 24,
                    curve: Curves.linearToEaseOut,
                    decoration: BoxDecoration(
                        color: calcHeight(height /
                            ((goalModel == null || goalModel.step <= 0)
                                ? 1500
                                : goalModel.step) *
                            100),
                        borderRadius: BorderRadius.circular(4)),
                  );
                },
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Text(
            widget.title,
            style: AppWidget.simpleTextFieldStyle(
                fontSize: 12,
                height: 14.63,
                color: Theme.of(context).color5,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat'),
          ),
        )
      ],
    );
  }
}
