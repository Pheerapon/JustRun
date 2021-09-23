import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_habit_run/app/bubble_button.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/graphql/config.dart';
import 'package:flutter_habit_run/common/graphql/mutations.dart';
import 'package:flutter_habit_run/common/route/routes.dart';
import 'package:flutter_habit_run/feature/home/screen/home.dart';
import 'package:graphql/client.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widget/walkthrough_widget.dart';

class SettingGoal extends StatefulWidget {
  @override
  _SettingGoalState createState() => _SettingGoalState();
}

class _SettingGoalState extends State<SettingGoal> {
  TextEditingController distanceCtl = TextEditingController();
  TextEditingController timeCtl = TextEditingController();
  TextEditingController stepsCtl = TextEditingController();
  FocusNode distanceFn = FocusNode();
  FocusNode timeFn = FocusNode();
  FocusNode stepsFn = FocusNode();

  Future<void> requestActivity({Widget child}) async {
    PermissionStatus status;
    if (Platform.isAndroid) {
      status = await Permission.activityRecognition.request();
    } else if (Platform.isIOS) {
      status = await Permission.sensors.request();
    }
    if (status.isGranted) {
      final User user = FirebaseAuth.instance.currentUser;
      await user.getIdToken().then((token) async {
        AppWidget.showDialogCustom(context: context);
        await Config.initializeClient(token).value.mutate(MutationOptions(
                document: gql(Mutations.addGoals()),
                variables: <String, dynamic>{
                  'distance': double.tryParse(distanceCtl.text) ?? 2.0,
                  'time': int.tryParse(timeCtl.text) ?? 120,
                  'step': int.tryParse(stepsCtl.text) ?? 1500,
                  'user_id': user.uid,
                }));
        Navigator.of(context).pop();
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.homeScreen, (route) => false,
            arguments: HomeScreen(
              currentIndex: child == null ? 0 : 1,
            ));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(AppWidget.customSnackBar(
          content: 'You must provide activity permission'));
    }
  }

  Widget handleAddGoals({Widget child, BuildContext context}) {
    return BubbleButton(
        onTap: () async {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            requestActivity(child: child);
          });
        },
        child: child ??
            AppWidget.typeButtonStartAction(
                input: 'Save & Run Later',
                bgColor: ultramarineBlue.withOpacity(0.1),
                textColor: ultramarineBlue));
  }

  @override
  void dispose() {
    distanceCtl.dispose();
    timeCtl.dispose();
    stepsCtl.dispose();
    distanceFn.dispose();
    timeFn.dispose();
    stepsFn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidget.createSimpleAppBar(
          context: context,
          onTap: () async {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              requestActivity();
            });
          }),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Set Running Goals',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 16),
                        child: Text(
                          'Define your goal and try to accomplish it!',
                          style: AppWidget.simpleTextFieldStyle(
                              fontSize: 16,
                              height: 24,
                              color: Theme.of(context).color4),
                        ),
                      ),
                      WalkThroughWidget.createTextField(
                          context: context,
                          controller: distanceCtl,
                          focusNode: distanceFn,
                          focusNext: timeFn,
                          autoFocus: true,
                          title: 'Distance',
                          suffixText: 'km'),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: WalkThroughWidget.createTextField(
                            context: context,
                            controller: timeCtl,
                            focusNode: timeFn,
                            focusNext: stepsFn,
                            title: 'Time',
                            suffixText: 'minute'),
                      ),
                      WalkThroughWidget.createTextField(
                          context: context,
                          controller: stepsCtl,
                          focusNode: stepsFn,
                          title: 'Steps',
                          suffixText: '')
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 132,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            handleAddGoals(
                child: AppWidget.typeButtonStartAction(
                    input: 'Run Now', bgColor: ultramarineBlue),
                context: context),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: handleAddGoals(context: context),
            )
          ],
        ),
      ),
    );
  }
}
