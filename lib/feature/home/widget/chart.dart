import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/util/format_time.dart';

import '../bloc/get_data_chart/get_data_chart_bloc.dart';
import '../bloc/get_data_chart/get_data_chart_state.dart';
import 'column_chart.dart';
import 'popup_show_steps.dart';

class Chart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> steps = [];
    return Container(
      height: 240,
      margin: const EdgeInsets.symmetric(vertical: 32),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).color2),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '${FormatTime.formatTime(format: Format.dMydMy)}',
                    style: AppWidget.simpleTextFieldStyle(
                        fontSize: 12,
                        height: 14.63,
                        color: Theme.of(context).color3,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: BlocBuilder<GetDataChartBloc, GetDataChartState>(
                builder: (context, state) {
                  if (state is GetDataChartSuccess) {
                    steps = state.steps;
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: 7,
                    separatorBuilder: (context, index) {
                      return index != 6
                          ? const SizedBox(
                              width: 20,
                            )
                          : const SizedBox();
                    },
                    itemBuilder: (context, index) {
                      return PopupShowSteps(
                        steps: int.tryParse(steps[index]['steps'].toString()),
                        child: ColumnChart(
                          height:
                              double.tryParse(steps[index]['steps'].toString()),
                          title: steps[index]['title'],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
