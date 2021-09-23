import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/route/routes.dart';
import '../bloc/dark_mode/bloc_dark_mode.dart';

class SettingScreen extends StatelessWidget {
  final List<Map<String, dynamic>> settingItem = [
    <String, dynamic>{
      'image': 'images/edit_profile@3x.png',
      'title': 'Edit Profile',
    },
    <String, dynamic>{
      'image': 'images/notification@3x.png',
      'title': 'Notifications',
    },
    <String, dynamic>{
      'image': 'images/term@3x.png',
      'title': 'Terms & Privacy',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidget.createSimpleAppBar(context: context),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: AppWidget.typeButtonStartAction(
            onPressed: () async {
              BlocProvider.of<DarkModeBloc>(context)
                  .add(const ChangeDarkMode(darkMode: false));
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.walkThrough, (route) => false);
            },
            input: 'Logout',
            bgColor: ultramarineBlue,
            vertical: 12),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Settings Accounts',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.only(
                    bottom: 24, left: 32, right: 32, top: 32),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (index == 1) {
                        Navigator.of(context).pushNamed(Routes.notification);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 16),
                          child: Image.asset(
                            settingItem[index]['image'],
                            width: 32,
                            height: 32,
                          ),
                        ),
                        Expanded(
                          child: Text(settingItem[index]['title'],
                              style: AppWidget.boldTextFieldStyle(
                                  fontSize: 18,
                                  height: 28,
                                  color: Theme.of(context).color8)),
                        ),
                        Image.asset(
                          'images/arrow-right@3x.png',
                          width: 24,
                          height: 24,
                          color: Theme.of(context).color14,
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return AppWidget.divider(context);
                },
                itemCount: settingItem.length),
          ],
        ),
      ),
    );
  }
}
