import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/opacity_clicked.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/constant/env.dart';
import 'package:flutter_habit_run/common/graphql/config.dart';
import 'package:flutter_habit_run/common/graphql/mutations.dart';
import 'package:flutter_habit_run/common/graphql/queries.dart';
import 'package:flutter_habit_run/common/route/routes.dart';
import 'package:flutter_habit_run/common/util/authentication_apple.dart';
import 'package:flutter_habit_run/common/util/authentication_google.dart';
import 'package:flutter_habit_run/feature/home/screen/home.dart';
import 'package:graphql/client.dart';

import '../bloc/state_play_stop/bloc_check_box.dart';
import '../widget/web_view_privacy.dart';

class OptionLogin extends StatelessWidget {
  Future<void> getGenderUser(
      {User firebaseUser, String token, BuildContext context}) async {
    await Config.initializeClient(token)
        .value
        .query(QueryOptions(
            document: gql(Queries.getGender),
            variables: <String, dynamic>{'id': firebaseUser.uid}))
        .then((value) {
      Navigator.of(context).pop();
      // print(value);
      // print('///');
      // print(value.data);
      // print('///');
      // print(value.data['User']);
      // print('///');
      // print(value.data['gender']);
      // print('///');
      // print(value.data[0]);

      if (value.data['User'][0]['gender'] == null) {
        Navigator.of(context).pushNamed(Routes.welcome);
      } else {
        Navigator.of(context)
            .pushNamed(Routes.homeScreen, arguments: const HomeScreen());
      }
    });
  }

  Future<void> signIn({User firebaseUser, BuildContext context}) async {
    String token;
    if (firebaseUser != null) {
      AppWidget.showDialogCustom(context: context);
      await firebaseUser.getIdTokenResult().then((value) async {
        token = value.token;
        final dynamic resultClaim = value.claims[EnvValue.hasuraClaim];
        if (resultClaim != null) {
          await getGenderUser(
              firebaseUser: firebaseUser, context: context, token: token);
        } else {
          FirebaseDatabase(databaseURL: EnvValue.databaseUrl)
              .reference()
              .child('metadata/${firebaseUser.uid}/refreshTime')
              .onValue
              .listen((event) async {
            if (event.snapshot.value == null) {
              return;
            }
            token = await firebaseUser.getIdToken(true);
            await Config.initializeClient(token).value.mutate(MutationOptions(
                    document: gql(Mutations.addUserInfo()),
                    variables: <String, dynamic>{
                      'id': firebaseUser.uid,
                      'email': firebaseUser.email,
                      'money': 0,
                      'name': firebaseUser.displayName,
                    }));
            await getGenderUser(
                firebaseUser: firebaseUser, context: context, token: token);
          });
        }
      });
    }
  }

  Widget createPrivacy({BuildContext context, String input, String url}) {
    return OpacityClicked(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(Routes.webViewPrivacy,
              arguments: WebViewPrivacy(
                title: input,
                url: url,
              ));
        },
        child: Text(
          input,
          style: AppWidget.simpleTextFieldStyle(
              height: 18,
              fontSize: 14,
              textDecoration: TextDecoration.underline,
              color: btnGoogle),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isChecked = false;
    return BlocBuilder<CheckBoxBloc, CheckBoxState>(
      cubit: BlocProvider.of<CheckBoxBloc>(context),
      builder: (context, state) {
        if (state is CheckBoxSuccess) {
          isChecked = state.isChecked;
        }
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  activeColor: ultramarineBlue,
                  value: isChecked,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  onChanged: (bool value) {
                    BlocProvider.of<CheckBoxBloc>(context)
                        .add(CheckedEvent(isChecked: isChecked));
                  },
                ),
                Row(
                  children: [
                    Text(
                      'I agree to the ',
                      style: AppWidget.simpleTextFieldStyle(
                          height: 18, fontSize: 14, color: ultramarineBlue),
                    ),
                    createPrivacy(
                        context: context,
                        input: 'Policy',
                        url: EnvValue.policy),
                        context: context, input: 'Terms', url: EnvValue.terms),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: AppWidget.typeButtonStartAction(
                  input: 'Login with Google',
                  onPressed: isChecked
                      ? () async {
                          final User firebaseUser =
                              await AuthenticationGoogle.signInWithGoogle(
                                  context: context);
                          signIn(firebaseUser: firebaseUser, context: context);
                        }
                      : () {},
                  bgColor: isChecked ? btnGoogle : grey500,
                  icon: 'images/google@3x.png'),
            ),
            Platform.isIOS
                ? SizedBox(
                    width: 280,
                    child: AppWidget.typeButtonStartAction(
                        input: 'Sign in with Apple',
                        borderRadius: 4,
                        bgColor: btnAppleID,
                        onPressed: isChecked
                            ? () async {
                                final User firebaseUser =
                                    await AuthenticationApple.signInWithApple(
                                        context: context);
                                signIn(
                                    firebaseUser: firebaseUser,
                                    context: context);
                              }
                            : () {},
                        icon: 'images/apple@3x.png'),
                  )
                : const SizedBox()
          ],
        );
      },
    );
  }
}
