import 'package:flutter/material.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/util/format_time.dart';
import 'package:provider/provider.dart';

import '../bloc/count_time/timer_bloc.dart';

class TimerText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int duration =
        context.select((TimerBloc bloc) => bloc.state.duration);
    return Text(
      FormatTime.convertTime(duration),
      style: AppWidget.boldTextFieldStyle(
          fontSize: 32,
          height: 37.5,
          color: Theme.of(context).color10,
          fontFamily: 'Futura',
          fontStyle: FontStyle.italic),
    );
  }
}
