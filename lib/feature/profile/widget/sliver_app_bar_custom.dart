import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/model/user_model.dart';
import 'package:flutter_habit_run/common/route/routes.dart';
import '../../home/bloc/save_info_user/save_info_user_bloc.dart';

import '../../home/widget/home_widget.dart';

class SliverAppBarCustom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = AppWidget.getHeightScreen(context);
    final UserModel userModel =
        BlocProvider.of<SaveInfoUserBloc>(context).userModel;
    return AppBar(
      elevation: 0,
      leadingWidth: 0,
      leading: const SizedBox(),
      flexibleSpace: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: Theme.of(context).color2,
            padding: const EdgeInsets.only(top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        userModel.gender == Gender.Female
                            ? 'gif/female_running.gif'
                            : 'gif/male_running.gif',
                        width: height / 203 * 30,
                        height: height / 203 * 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24, right: 12),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Image.asset(
                                'images/icon_money@3x.png',
                                width: 16,
                                height: 24,
                              ),
                            ),
                            HomeWidget.money(
                                context: context,
                                amount: userModel.money
                                    .toString()
                                    .replaceAllMapped(
                                        HomeWidget.reg, HomeWidget.mathFunc))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${userModel.name}',
                              style: AppWidget.simpleTextFieldStyle(
                                  color: Theme.of(context).color9,
                                  fontSize: 18,
                                  height: 32),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(Routes.settings);
                              },
                              child: Image.asset(
                                'images/arrow-right@3x.png',
                                width: 24,
                                height: 24,
                                color: Theme.of(context).color14,
                              ),
                            )
                          ],
                        ),
                        Text(
                          '${userModel.email}',
                          style: AppWidget.simpleTextFieldStyle(
                              color: Theme.of(context).color12,
                              fontSize: 14,
                              height: 16.71),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
            ),
            bottom: -1,
            left: 0,
            right: 0,
          ),
        ],
      ),
    );
  }
}
