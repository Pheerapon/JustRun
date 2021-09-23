import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/model/user_model.dart';
import '../bloc/save_info_user/bloc_save_info_user.dart';

import '../bloc/save_info_user/save_info_user_bloc.dart';
import 'home_widget.dart';

class AppBarHome {
  PreferredSize createAppBar({BuildContext context, double width}) {
    UserModel userModel;
    final height = AppWidget.getHeightScreen(context);
    return PreferredSize(
      preferredSize: Size(width, height / 203 * 30),
      child: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          padding: const EdgeInsets.only(top: 24),
          child: BlocBuilder<SaveInfoUserBloc, SaveInfoUserState>(
            builder: (context, state) {
              if (state is SaveInfoUserSuccess) {
                userModel = state.userModel;
              }
              return userModel == null
                  ? const SizedBox()
                  : Row(
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
                          padding: const EdgeInsets.only(top: 25, right: 15),
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
                    );
            },
          ),
        ),
      ),
    );
  }
}
