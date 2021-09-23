import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/model/badge_model.dart';

class BadgeItem extends StatelessWidget {
  const BadgeItem(this.badge);
  final BadgeModel badge;
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: badge.acquired ? 1 : 0.5,
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              'images/badges/${badge.title.split(" ").join("")}.png',
              width: 72,
              height: 72,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (badge.acquired)
                Container(
                  margin: const EdgeInsets.only(right: 4),
                  child: Image.asset(
                    'images/check@3x.png',
                    width: 10,
                    height: 10,
                  ),
                ),
              Text(
                badge.title.toUpperCase(),
                style: AppWidget.boldTextFieldStyle(
                    fontSize: 12, height: 18, color: Theme.of(context).color8),
              ),
            ],
          ),
          Text(
            badge.subtitle.toUpperCase(),
            style: AppWidget.boldTextFieldStyle(
                fontSize: 12, height: 18, color: Theme.of(context).color8),
          ),
        ],
      ),
    );
  }
}
