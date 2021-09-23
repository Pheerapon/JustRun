import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/graphql/config.dart';
import 'package:flutter_habit_run/common/graphql/mutations.dart';
import 'package:flutter_habit_run/common/preference/shared_preference_builder.dart';
import 'package:flutter_habit_run/common/route/routes.dart';
import 'package:graphql/client.dart';
import '../widget/choose_gender.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = AppWidget.getHeightScreen(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppWidget.createSimpleAppBar(context: context, hasPop: false),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 75),
                  child: Text(
                    'Choose your Gender',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                SizedBox(height: height / 203 * 92, child: ChooseGender()),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 40),
                  child: AppWidget.typeButtonStartAction(
                      onPressed: () async {
                        AppWidget.showDialogCustom(context: context);
                        await getShared().then((gender) {
                          if (gender != null) {
                            final User user = FirebaseAuth.instance.currentUser;
                            user.getIdToken().then((token) async {
                              await Config.initializeClient(token)
                                  .value
                                  .mutate(
                                      MutationOptions(
                                          document:
                                              gql(Mutations.updateGender()),
                                          variables: <String, dynamic>{
                                        'id': user.uid,
                                        'gender': gender
                                      }));
                              Navigator.of(context).pop();
                              Navigator.of(context)
                                  .pushNamed(Routes.settingGoal);
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                AppWidget.customSnackBar(
                                    content: 'Please choose your gender'));
                          }
                        });
                      },
                      input: 'Next',
                      bgColor: ultramarineBlue),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
