import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/model/run_history_model.dart';
import 'package:flutter_habit_run/common/util/format_time.dart';
import 'package:intl/intl.dart';

class ItemHistory extends StatelessWidget {
  const ItemHistory({this.runHistory});
  final RunHistoryModel runHistory;

  @override
  Widget build(BuildContext context) {
    final DateTime date =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").parse(runHistory.date);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date.day.toString(),
                style: AppWidget.boldTextFieldStyle(
                    fontSize: 20, height: 30, color: caribbeanGreen),
              ),
              Text(
                FormatTime.formatTime(format: Format.My, dateTime: date)
                    .toUpperCase(),
                style: AppWidget.boldTextFieldStyle(
                  fontSize: 12,
                  height: 18,
                  color: Theme.of(context).color4,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                runHistory.distance.toStringAsFixed(2),
                style: AppWidget.boldTextFieldStyle(
                  fontSize: 18,
                  height: 28,
                  color: Theme.of(context).color8,
                ),
              ),
              Text('km',
                  style: AppWidget.simpleTextFieldStyle(
                      fontSize: 14,
                      height: 21,
                      color: Theme.of(context).color4))
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                runHistory.time,
                style: AppWidget.boldTextFieldStyle(
                  fontSize: 18,
                  height: 28,
                  color: Theme.of(context).color8,
                ),
              ),
              Text('min',
                  style: AppWidget.simpleTextFieldStyle(
                      fontSize: 14,
                      height: 21,
                      color: Theme.of(context).color4))
            ],
          ),
        ),
        Expanded(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.memory(
                base64Decode(runHistory.image),
                height: 40,
                fit: BoxFit.cover,
              )),
        ),
      ],
    );
  }
}
