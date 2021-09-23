import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/common/constant/dark_mode.dart';
import 'package:flutter_habit_run/common/preference/shared_preference_builder.dart';
import 'package:flutter_habit_run/common/route/route_generator.dart';
import 'package:flutter_habit_run/feature/home/screen/home.dart';
import 'package:flutter_habit_run/feature/profile/bloc/dark_mode/bloc_dark_mode.dart';
import 'package:flutter_habit_run/feature/walkthrough/screen/welcome.dart';
import 'package:flutter_habit_run/feature/walkthrough/screen/walkthrough.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../main.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeMode;

  Future<void> checkDarkMode() async {
    if (themeMode == null) {
      await getValueBool(input: 'darkMode').then((value) {
        if (value != null) {
          if (value) {
            themeMode = ThemeMode.dark;
          } else {
            themeMode = ThemeMode.light;
          }
        } else {
          themeMode = ThemeMode.light;
        }
      });
    }
  }

  @override
  void initState() {
    checkDarkMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return FutureBuilder(
      future: checkDarkMode(),
      builder: (context, snapshot) {
        return BlocBuilder<DarkModeBloc, DarkModeState>(
          builder: (context, state) {
            if (state is DarkModeSuccess) {
              themeMode = state.themeMode;
            }
            return MaterialApp(
                navigatorObservers: [
                  SentryNavigatorObserver(),
                ],
                initialRoute: '/',
                onGenerateRoute: RouteGenerator.generateRoute,
                title: 'HabitRun',
                debugShowCheckedModeBanner: false,
                theme: lightMode,
                darkTheme: darkMode,
                themeMode: themeMode,
                home: userModel == null
                    ? AnnotatedRegion<SystemUiOverlayStyle>(
                        value: const SystemUiOverlayStyle(
                          statusBarColor: Colors.transparent,
                          statusBarIconBrightness: Brightness.light,
                          statusBarBrightness: Brightness.dark,
                        ),
                        child: WalkThrough())
                    : (userModel.gender == null
                        ? AnnotatedRegion<SystemUiOverlayStyle>(
                            value: const SystemUiOverlayStyle(
                              statusBarColor: Colors.transparent,
                              statusBarIconBrightness: Brightness.light,
                              statusBarBrightness: Brightness.dark,
                            ),
                            child: Welcome())
                        : const AnnotatedRegion<SystemUiOverlayStyle>(
                            value: SystemUiOverlayStyle(
                              statusBarColor: Colors.transparent,
                              statusBarIconBrightness: Brightness.light,
                              statusBarBrightness: Brightness.dark,
                            ),
                            child: HomeScreen())));
          },
        );
      },
    );
  }
}
