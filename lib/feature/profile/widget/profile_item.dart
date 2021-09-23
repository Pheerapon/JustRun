import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/preference/shared_preference_builder.dart';
import 'package:flutter_habit_run/common/route/routes.dart';
import '../bloc/dark_mode/bloc_dark_mode.dart';

class ProfileItem extends StatefulWidget {
  const ProfileItem({this.item, this.index});
  final Map<String, dynamic> item;
  final int index;

  @override
  _ProfileItemState createState() => _ProfileItemState();
}

class _ProfileItemState extends State<ProfileItem> {
  bool themeMode = false;

  Future<void> checkDarkMode() async {
    await getValueBool(input: 'darkMode').then((value) {
      themeMode = value ?? false;
    });
  }

  Widget createWidget(BuildContext context) {
    switch (widget.index) {
      case 0:
        return Image.asset(
          'images/arrow-right@3x.png',
          width: 24,
          height: 24,
          color: Theme.of(context).color14,
        );
      case 1:
        return Image.asset(
          'images/arrow-right@3x.png',
          width: 24,
          height: 24,
          color: Theme.of(context).color14,
        );
      default:
        return BlocBuilder<DarkModeBloc, DarkModeState>(
          builder: (context, state) {
            if (state is DarkModeSuccess) {
              themeMode = state.darkMode;
            }
            return CupertinoSwitch(
                activeColor: ultramarineBlue,
                value: themeMode,
                onChanged: (value) async {
                  await setShared(!themeMode, 'darkMode');
                  BlocProvider.of<DarkModeBloc>(context)
                      .add(ChangeDarkMode(darkMode: value));
                });
          },
        );
    }
  }

  @override
  void initState() {
    checkDarkMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.index == 0) {
          Navigator.of(context).pushNamed(Routes.badges);
        } else if (widget.index == 1) {
          Navigator.of(context).pushNamed(Routes.runHistory);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Image.asset(
              widget.item['image'],
              width: 32,
              height: 32,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.item['title'],
                    style: AppWidget.boldTextFieldStyle(
                        fontSize: 18,
                        height: 28,
                        color: Theme.of(context).color8)),
                widget.item['subtitle'] != null
                    ? Text(
                        widget.index == 1
                            ? '${widget.item['subtitle']}today'
                            : widget.item['subtitle'],
                        style: AppWidget.simpleTextFieldStyle(
                            fontSize: 14, height: 21, color: grey600),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return createWidget(context);
              }
              return createWidget(context);
            },
            future: checkDarkMode(),
          )
        ],
      ),
    );
  }
}
