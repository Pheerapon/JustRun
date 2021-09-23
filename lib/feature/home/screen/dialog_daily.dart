import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
// import 'package:flutter_habit_run/common/constant/env.dart';
import 'package:flutter_habit_run/common/graphql/config.dart';
import 'package:flutter_habit_run/common/graphql/mutations.dart';
import 'package:flutter_habit_run/common/graphql/queries.dart';
import 'package:flutter_habit_run/common/model/user_model.dart';
// import 'package:flutter_habit_run/feature/home/screen/ads_reward.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:graphql/client.dart';

import '../bloc/get_reward_daily/bloc_get_reward_daily.dart';
import '../bloc/save_info_user/bloc_save_info_user.dart';
import '../widget/home_widget.dart';

class DailyDialog extends StatefulWidget {
  @override
  _DailyDialogState createState() => _DailyDialogState();
}

class _DailyDialogState extends State<DailyDialog> {
  SaveInfoUserBloc saveInfoUserBloc;
  // BannerAd _ad;
  // bool _isAdLoaded = false;
  Future<void> updateDailyReward(BuildContext context, int daysInRow) async {
    final int point = checkPoint(daysInRow - 1);
    final User user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      user.getIdToken().then((token) async {
        await Config.initializeClient(token).value.mutate(MutationOptions(
                document: gql(Mutations.updateRewardDaily()),
                variables: <String, dynamic>{
                  'user_id': user.uid,
                  'days_row': daysInRow,
                  'current_daily': DateTime.now().toIso8601String()
                }));
        await Config.initializeClient(token).value.mutate(MutationOptions(
                document: gql(Mutations.updateMoney()),
                variables: <String, dynamic>{
                  'user_id': user.uid,
                  'money': saveInfoUserBloc.userModel.money + point
                }));
        Config.initializeClient(token)
            .value
            .query(QueryOptions(
                document: gql(Queries.getInfoUser),
                variables: <String, dynamic>{'id': user.uid}))
            .then((value) {
          saveInfoUserBloc.add(SaveInfoEvent(
              userModel: UserModel.fromJson(value.data['User'][0])));
        });
      });
    }
    Navigator.of(context).pop();
  }

  int checkPoint(int index) {
    int point = 100;
    switch (index) {
      case 5:
        point = 200;
        break;
      case 11:
        point = 400;
        break;
      case 17:
        point = 600;
        break;
      case 23:
        point = 800;
        break;
      case 29:
        point = 1000;
        break;
      default:
        point = 100;
        break;
    }
    return point;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _ad = BannerAd(
  //     adUnitId: AdHelper().bannerAdUnitId,
  //     size: AdSize.banner,
  //     request: const AdRequest(),
  //     listener: BannerAdListener(
  //       onAdLoaded: (_) {
  //         setState(() {
  //           _isAdLoaded = true;
  //         });
  //       },
  //       onAdFailedToLoad: (ad, error) {
  //         ad.dispose();
  //         print('Ad load failed (code=${error.code} message=${error.message})');
  //       },
  //     ),
  //   );
  //   _ad.load();
  // }

  // @override
  // void dispose() {
  //   _ad.dispose();
  //   super.dispose();
  // }

  @override
  void didChangeDependencies() {
    saveInfoUserBloc = BlocProvider.of<SaveInfoUserBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel;
    int daysInRow;
    int point = 100;
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.close,
                    color: Theme.of(context).color9, size: 24),
              ),
              Row(
                children: [
                  BlocBuilder<SaveInfoUserBloc, SaveInfoUserState>(
                    builder: (context, state) {
                      if (state is SaveInfoUserSuccess) {
                        userModel = state.userModel;
                      }
                      return userModel == null
                          ? const SizedBox()
                          : Row(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Image.asset(
                                        'images/icon_money@3x.png',
                                        width: 16,
                                        height: 24)),
                                HomeWidget.money(
                                    context: context,
                                    amount: userModel.money
                                        .toString()
                                        .replaceAllMapped(HomeWidget.reg,
                                            HomeWidget.mathFunc))
                              ],
                            );
                    },
                  )
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Check in and',
                  style: Theme.of(context).textTheme.headline1,
                ),
                Text(
                  'Get Points',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ],
            ),
          ),
          BlocBuilder<GetRewardDailyBloc, GetRewardDailyState>(
            builder: (context, state) {
              if (state is GetRewardDailySuccess) {
                daysInRow = state.dailyRewardModel.daysInRow;
              }
              return Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: 30,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            crossAxisCount: 6),
                    itemBuilder: (context, index) {
                      point = checkPoint(index);
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color:
                                index >= daysInRow ? grey200 : ultramarineBlue),
                        child: Center(
                          child: Text('$point',
                              textAlign: TextAlign.center,
                              style: AppWidget.boldTextFieldStyle(
                                  fontSize: 14,
                                  height: 16.41,
                                  fontFamily: 'Montserrat',
                                  fontStyle: FontStyle.italic,
                                  color: index >= daysInRow
                                      ? Theme.of(context).color14
                                      : white)),
                        ),
                      );
                    },
                  ),
                  // AdsReward(
                  //   function: updateDailyReward,
                  //   daysInRow: daysInRow + 1,
                  //   child: AppWidget.typeButtonStartAction(
                  //       input: 'Checkin', bgColor: ultramarineBlue),
                  // ),
                ],
              );
            },
          ),
          const Expanded(child: SizedBox()),
          // _isAdLoaded
          //     ? Container(
          //         height: 100,
          //         child: AdWidget(
          //           ad: _ad,
          //         ),
          //       )
          //     : const SizedBox()
        ],
      ),
    ));
  }
}
