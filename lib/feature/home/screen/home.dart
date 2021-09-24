import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/graphql/config.dart';
import 'package:flutter_habit_run/common/graphql/mutations.dart';
import 'package:flutter_habit_run/common/graphql/queries.dart';
import 'package:flutter_habit_run/common/model/daily_reward_model.dart';
import 'package:flutter_habit_run/common/model/goal_model.dart';

import 'package:flutter_habit_run/common/model/run_history_model.dart';
import 'package:flutter_habit_run/feature/home/api_helper.dart';
import 'package:graphql/client.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../profile/screen/profile.dart';
import '../bloc/get_data_chart/bloc_get_data_chart.dart';
import '../bloc/get_reward_daily/bloc_get_reward_daily.dart';
import '../bloc/save_goal/bloc_save_goal.dart';
import '../bloc/save_info_user/bloc_save_info_user.dart';
import '../update_widget.dart';
import '../widget/app_bar_home.dart';
import '../widget/home_widget.dart';
import 'dash_board.dart';
import 'runner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({this.currentIndex = 1});
  final int currentIndex;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  List<String> listPathIcon = [];
  List<Widget> listWidget = [];
  int _currentIndex = 1;
  List<RunHistoryModel> run7Histories = [];
  PermissionStatus status;

  GetDataChartBloc getDataChartBloc;
  SaveInfoUserBloc saveInfoUserBloc;
  GetRewardDailyBloc getRewardDailyBloc;
  SaveGoalBloc saveGoalBloc;

  Future<void> getGoal() async {
    double distance;
    int steps = 0;
    GoalModel goalModel;
    DailyRewardModel dailyRewardModel;
    final User user = FirebaseAuth.instance.currentUser;
    await user.getIdToken().then((token) async {
      await Config.initializeClient(token)
          .value
          .query(QueryOptions(
              document: gql(Queries.getGoal),
              variables: <String, dynamic>{'user_id': user.uid}))
          .then((value) {
        goalModel = GoalModel.fromJson(value.data['Goal'][0]);
        saveGoalBloc.add(SaveGoal(goalModel: goalModel));
      });
      await Config.initializeClient(token)
          .value
          .query(QueryOptions(
              document: gql(Queries.getRewardDaily),
              variables: <String, dynamic>{'user_id': user.uid}))
          .then((value) async {
        if ((value.data['DailyReward'] as List).isNotEmpty) {
          dailyRewardModel =
              DailyRewardModel.fromJson(value.data['DailyReward'][0]);
        } else {
          await Config.initializeClient(token).value.mutate(MutationOptions(
                  document: gql(Mutations.insertRewardDaily()),
                  variables: <String, dynamic>{
                    'user_id': user.uid,
                    'current_daily': DateTime.now()
                        .subtract(const Duration(days: 2))
                        .toIso8601String()
                  }));
          dailyRewardModel = DailyRewardModel(
              daysInRow: 0,
              currentDaily: DateTime.now()
                  .subtract(const Duration(days: 2))
                  .toIso8601String());
        }
        getRewardDailyBloc
            .add(SaveStateGetRewardDaily(dailyRewardModel: dailyRewardModel));
      });
      await Config.initializeClient(token)
          .value
          .query(QueryOptions(
              document: gql(Queries.getSumDistanceToday),
              variables: <String, dynamic>{
                'user_id': user.uid,
                'date': DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day)
                    .toIso8601String()
              }))
          .then((value) {
        distance = double.tryParse(value.data['RunHistory_aggregate']
                    ['aggregate']['sum']['distance']
                .toString()) ??
            0.0;
        steps = value.data['RunHistory_aggregate']['aggregate']['sum']
                ['steps'] ??
            0;
        updateHomeWidget('Today', distance.toStringAsFixed(2),
            (steps / goalModel.step * 100).toInt());
      });
    });
  }

  Future<void> requestActivity() async {
    if (Platform.isAndroid) {
      status = await Permission.activityRecognition.request();
    } else if (Platform.isIOS) {
      status = await Permission.sensors.request();
    }
    if (status.isDenied && !status.isPermanentlyDenied) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        requestActivity();
      });
    } else {
      setState(() {});
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    getDataChartBloc = BlocProvider.of<GetDataChartBloc>(context);
    saveGoalBloc = BlocProvider.of<SaveGoalBloc>(context);
    saveInfoUserBloc = BlocProvider.of<SaveInfoUserBloc>(context);
    getRewardDailyBloc = BlocProvider.of<GetRewardDailyBloc>(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    listPathIcon = [
      'images/dashboard@3x.png',
      'images/runner@3x.png',
      'images/profile@3x.png',
    ];
    getGoal().whenComplete(() {
      if (getRewardDailyBloc.showDialog) {
        Future.delayed(const Duration(seconds: 3), () {
         
        });
      }
    });
    requestActivity().whenComplete(() {
      _currentIndex = widget.currentIndex;
      ApiHelper().getInfoUser(run7Histories: run7Histories).then((value) {
        if (mounted) {
          setState(() {
            listWidget = [
              DashBoard(),
              Runner(),
              Profile(
                userBadges: value.badges,
              ),
            ];
            getDataChartBloc.add(GetDataEvent(runHistories: run7Histories));
            saveInfoUserBloc.add(SaveInfoEvent(userModel: value));
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final width = AppWidget.getWidthScreen(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: status.isGranted
          ? Scaffold(
              appBar: _currentIndex == 2
                  ? null
                  : AppBarHome().createAppBar(context: context, width: width),
              body: listWidget.isEmpty
                  ? const Center(
                      child: CupertinoActivityIndicator(animating: true))
                  : listWidget.elementAt(_currentIndex),
              bottomNavigationBar: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: BottomNavigationBar(
                  currentIndex: _currentIndex,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                  onTap: (value) {
                    setState(() {
                      _currentIndex = value;
                    });
                  },
                  items: [
                    HomeWidget.createItemNav(
                        context: context,
                        pathIcon: listPathIcon[0],
                        label: 'DashBoard'),
                    HomeWidget.createItemNav(
                        context: context,
                        pathIcon: listPathIcon[1],
                        label: 'Runner'),
                    HomeWidget.createItemNav(
                        context: context,
                        pathIcon: listPathIcon[2],
                        label: 'Profile'),
                  ],
                ),
              ),
            )
          : const Scaffold(),
    );
  }
}
