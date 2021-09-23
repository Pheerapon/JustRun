import 'package:flutter/material.dart';
import 'package:flutter_habit_run/feature/home/screen/camera.dart';
import 'package:flutter_habit_run/feature/home/screen/count_down.dart';
import 'package:flutter_habit_run/feature/home/screen/finish_run.dart';
import 'package:flutter_habit_run/feature/home/screen/home.dart';
import 'package:flutter_habit_run/feature/profile/screen/badges_screen.dart';
import 'package:flutter_habit_run/feature/profile/screen/notifications.dart';
import 'package:flutter_habit_run/feature/profile/screen/run_history.dart';
import 'package:flutter_habit_run/feature/profile/screen/setting.dart';
import 'package:flutter_habit_run/feature/walkthrough/screen/welcome.dart';
import 'package:flutter_habit_run/feature/walkthrough/screen/setting_goal.dart';
import 'package:flutter_habit_run/feature/home/screen/running.dart';
import 'package:flutter_habit_run/feature/walkthrough/screen/walkthrough.dart';
import 'package:flutter_habit_run/feature/walkthrough/widget/web_view_privacy.dart';
import 'routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      /// route catalog WalkThrough
      case Routes.walkThrough:
        return MaterialPageRoute<dynamic>(
          builder: (context) => WalkThrough(),
        );
      case Routes.welcome:
        return MaterialPageRoute<dynamic>(
          builder: (context) => Welcome(),
        );
      case Routes.settingGoal:
        return MaterialPageRoute<dynamic>(
          builder: (context) => SettingGoal(),
        );
      case Routes.webViewPrivacy:
        final WebViewPrivacy arg = settings.arguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) => WebViewPrivacy(
            url: arg.url,
            title: arg.title,
          ),
        );

      /// route catalog Home
      case Routes.homeScreen:
        final HomeScreen arg = settings.arguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) => HomeScreen(
            currentIndex: arg.currentIndex,
          ),
        );
      case Routes.countDown:
        final CountDown arg = settings.arguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) => CountDown(
            oldStep: arg.oldStep,
          ),
        );
      case Routes.running:
        final Running arg = settings.arguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) => Running(
            oldStep: arg.oldStep,
          ),
        );
      case Routes.camera:
        final Camera arg = settings.arguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) => Camera(
            distance: arg.distance,
            steps: arg.steps,
            time: arg.time,
          ),
        );
      case Routes.finishRun:
        final FinishRun args = settings.arguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) => FinishRun(
            steps: args.steps,
            time: args.time,
            distance: args.distance,
          ),
        );

      /// route profile
      case Routes.badges:
        return MaterialPageRoute<dynamic>(
          builder: (context) => BadgeScreen(),
        );
      case Routes.settings:
        return MaterialPageRoute<dynamic>(
          builder: (context) => SettingScreen(),
        );
      case Routes.runHistory:
        return MaterialPageRoute<dynamic>(
          builder: (context) => RunHistory(),
        );
      case Routes.notification:
        return MaterialPageRoute<dynamic>(
          builder: (context) => Notifications(),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute<dynamic>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
