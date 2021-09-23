import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/create_notify.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:graphql/client.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'app/app.dart';
import 'common/bloc/connectivity/bloc_connectivity.dart';
import 'common/graphql/config.dart';
import 'common/graphql/mutations.dart';
import 'common/graphql/queries.dart';
import 'common/model/user_model.dart';
import 'feature/home/bloc/count_time/timer_bloc.dart';
import 'feature/home/bloc/get_data_chart/get_data_chart_bloc.dart';
import 'feature/home/bloc/get_reward_daily/bloc_get_reward_daily.dart';
import 'feature/home/bloc/request_location/bloc_request_location.dart';
import 'feature/home/bloc/save_goal/bloc_save_goal.dart';
import 'feature/home/bloc/save_info_user/bloc_save_info_user.dart';
import 'feature/home/bloc/save_points_user/bloc_save_points.dart';
import 'feature/home/bloc/state_play_stop/bloc_running.dart';
import 'feature/profile/bloc/dark_mode/bloc_dark_mode.dart';
import 'feature/profile/bloc/get_all_badges/get_all_badges_bloc.dart';
import 'feature/profile/bloc/notifications/notifications_bloc.dart';
import 'feature/walkthrough/bloc/slider/slider_bloc.dart';
import 'feature/walkthrough/bloc/state_play_stop/bloc_check_box.dart';

List<CameraDescription> cameras;
UserModel userModel;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await MobileAds.instance.initialize();
  await Firebase.initializeApp();
  tz.initializeTimeZones();
  cameras = await availableCameras();
  await CreateNotify().createNotification();
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'Steps',
      channelName: 'Tracking Steps',
      channelDescription: 'Tracking Steps User',
      defaultColor: const Color(0XFF9050DD),
      ledColor: white,
      playSound: true,
      enableLights: true,
      enableVibration: true,
    ),
  ]);
  userModel = await getUser();
  final MultiBlocProvider blocProvider = MultiBlocProvider(
    providers: [
      BlocProvider<ConnectivityBloc>(
        create: (BuildContext context) =>
            ConnectivityBloc()..add(ListenConnection()),
      ),
      BlocProvider<SliderBloc>(
        create: (BuildContext context) => SliderBloc(),
      ),
      BlocProvider<SaveInfoUserBloc>(
        create: (BuildContext context) => SaveInfoUserBloc(),
      ),
      BlocProvider<SaveGoalBloc>(
        create: (BuildContext context) => SaveGoalBloc(),
      ),
      BlocProvider<RunningBloc>(
        create: (BuildContext context) => RunningBloc(),
      ),
      BlocProvider<SavePointsBloc>(
        create: (BuildContext context) => SavePointsBloc(),
      ),
      BlocProvider<GetDataChartBloc>(
        create: (BuildContext context) => GetDataChartBloc(),
      ),
      BlocProvider<GetRewardDailyBloc>(
        create: (BuildContext context) => GetRewardDailyBloc(),
      ),
      BlocProvider<RequestLocationBloc>(
        create: (BuildContext context) => RequestLocationBloc(),
      ),
      BlocProvider<CheckBoxBloc>(
        create: (BuildContext context) => CheckBoxBloc(),
      ),
      BlocProvider<TimerBloc>(
        create: (BuildContext context) => TimerBloc(),
      ),
      BlocProvider<GetAllBadgesBloc>(
        create: (BuildContext context) => GetAllBadgesBloc(),
      ),
      BlocProvider<DarkModeBloc>(
        create: (BuildContext context) => DarkModeBloc(),
      ),
      BlocProvider<NotificationsBloc>(
        create: (BuildContext context) => NotificationsBloc(),
      ),
    ],
    child: const MyApp(),
  );
  runZonedGuarded(() async {
    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://a587457d02e64135962a44d22bca1b29@o889705.ingest.sentry.io/5838879';
      },
    );

    runApp(blocProvider);
  }, (exception, stackTrace) async {
    await Sentry.captureException(exception, stackTrace: stackTrace);
  });
}

Future<UserModel> getUser() async {
  User firebaseUser;
  UserModel user;
  try {
    firebaseUser = FirebaseAuth.instance.currentUser;
    await firebaseUser.getIdToken().then((token) async {
      await Config.initializeClient(token)
          .value
          .query(QueryOptions(
              document: gql(Queries.getInfoUser),
              variables: <String, dynamic>{'id': firebaseUser.uid}))
          .then((value) {
        user = UserModel.fromJson(value.data['User'][0]);
      });
      await Config.initializeClient(token)
          .value
          .query(QueryOptions(
              document: gql(Queries.getGoal),
              variables: <String, dynamic>{'user_id': firebaseUser.uid}))
          .then((value) async {
        if (value.data['Goal'].isEmpty) {
          await Config.initializeClient(token).value.mutate(MutationOptions(
                  document: gql(Mutations.addGoals()),
                  variables: <String, dynamic>{
                    'distance': 2.0,
                    'time': 120,
                    'step': 1000,
                    'user_id': firebaseUser.uid,
                  }));
        }
      });
    });
    return user;
  } catch (e) {
    print(e);
    return null;
  }
}
