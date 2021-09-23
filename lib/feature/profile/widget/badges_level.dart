import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/model/badge_model.dart';
import 'package:flutter_habit_run/feature/profile/widget/badges_item.dart';

class BadgeLevel extends StatelessWidget {
  BadgeLevel(this.level);
  final List<BadgeModel> level;
  final List<Color> levelColor = [
    sandyBrown,
    caribbeanGreen,
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.only(right: 8),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: levelColor[level[0].level - 1].withOpacity(0.2)),
              child: Image.asset(
                'images/badges/level${level[0].level.toString()}.png',
                width: 16,
                height: 16,
              ),
            ),
            Text(
              'Level ' + level[0].level.toString(),
              style: AppWidget.boldTextFieldStyle(
                  fontSize: 18, height: 28, color: Theme.of(context).color9),
            ),
          ],
        ),
        GridView.count(
          padding: const EdgeInsets.symmetric(vertical: 24),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1,
          mainAxisSpacing: 24,
          crossAxisCount: 3,
          children: level.map((list) => BadgeItem(list)).toList(),
        ),
      ],
    );
  }
}
