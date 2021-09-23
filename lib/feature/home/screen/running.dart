import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/model/user_model.dart';
import 'package:flutter_habit_run/feature/home/widget/custom_google_map.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pedometer/pedometer.dart';

import '../bloc/count_time/timer_bloc.dart';
import '../bloc/save_info_user/save_info_user_bloc.dart';
import '../bloc/save_points_user/bloc_save_points.dart';
import '../widget/button_control_widget.dart';
import '../widget/home_widget.dart';

class Running extends StatefulWidget {
  const Running({this.oldStep});
  final int oldStep;
  @override
  _RunningState createState() => _RunningState();
}

class _RunningState extends State<Running> {
  Stream<StepCount> _stepCountStream;
  Stream<PedestrianStatus> _pedestrianStatusStream;
  int newStep = 0;
  int currentTime = 0;
  AwesomeNotifications awesomeNotifications = AwesomeNotifications();
  Timer timerLocation;
  int count = 1;

  FlutterTts flutterTts = FlutterTts();

  void onStepCount(StepCount event) {
    setState(() {
      newStep = event.steps ?? 0;
    });
    speakNotification();
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
  }

  void onStepCountError(dynamic error) {
    print('onStepCountError: $error');
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream.listen(onPedestrianStatusChanged);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
    if (!mounted) {
      return;
    }
  }

  Future<void> checkDistance({int stone, int distance}) async {
    if ((newStep - widget.oldStep) * 78 >= stone) {
      count++;
      await flutterTts.speak('You ran $distance kilometer');
      await flutterTts.awaitSpeakCompletion(true);
    }
  }

  Future<void> speakNotification() async {
    switch (count) {
      case 1:
        checkDistance(stone: 100000, distance: 1);
        break;
      case 2:
        checkDistance(stone: 200000, distance: 2);
        break;
      case 3:
        checkDistance(stone: 300000, distance: 3);
        break;
      case 4:
        checkDistance(stone: 400000, distance: 4);
        break;
      case 5:
        checkDistance(stone: 500000, distance: 5);
        break;
    }
  }

  @override
  void initState() {
    newStep = widget.oldStep;
    initPlatformState();
    HomeWidget.getCurrentLocation().then((value) {
      BlocProvider.of<SavePointsBloc>(context).add(
          SavePointEvent(position: LatLng(value.latitude, value.longitude)));
    });
    timerLocation = Timer.periodic(const Duration(seconds: 10), (Timer t) {
      HomeWidget.getCurrentLocation().then((value) {
        BlocProvider.of<SavePointsBloc>(context).add(
            SavePointEvent(position: LatLng(value.latitude, value.longitude)));
      });
    });
    if (Platform.isAndroid) {
      BlocProvider.of<TimerBloc>(context).listen((value) {
        currentTime = value.duration;
        HomeWidget.createNotification(
            currentTime: currentTime,
            newStep: newStep - widget.oldStep,
            awesomeNotifications: awesomeNotifications);
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    timerLocation.cancel();
    flutterTts.stop();
    awesomeNotifications.cancel(1);
    awesomeNotifications.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = AppWidget.getWidthScreen(context);
    final bool hasFemale =
        BlocProvider.of<SaveInfoUserBloc>(context).userModel.gender ==
            Gender.Female;
    final double amount = (newStep - widget.oldStep) * 78 / 100000 < 1
        ? (newStep - widget.oldStep) * 78 / 100
        : (newStep - widget.oldStep) * 78 / 100000;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          alignment: Alignment.centerRight,
          children: [
            Stack(
              children: [
                SizedBox(
                    width: width,
                    child: FutureBuilder(
                      future: HomeWidget.getCurrentLocation(),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          return CustomGoogleMap(
                            zoom: 16,
                            position: snapshot.data,
                            polyLines: const <Polyline>{},
                            circles: {
                              Circle(
                                  circleId: const CircleId('currentLocation'),
                                  center: LatLng(snapshot.data.latitude,
                                      snapshot.data.longitude),
                                  radius: 180,
                                  strokeWidth: 0,
                                  fillColor: ultramarineBlue.withOpacity(0.1))
                            },
                          );
                        }
                        return const Center(
                          child: CupertinoActivityIndicator(animating: true),
                        );
                      },
                    )),
                Container(
                  width: width,
                  decoration:
                      BoxDecoration(gradient: Theme.of(context).colorGoogle),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 48, left: 34),
                        child: HomeWidget.createDistance(
                            context: context,
                            amount: amount,
                            title: newStep == 0
                                ? 'm'
                                : (newStep - widget.oldStep) * 78 / 100000 < 1
                                    ? 'm'
                                    : 'Km'),
                      ),
                      Expanded(
                        child: ButtonControlWidget(
                          newStep: newStep,
                          oldStep: widget.oldStep,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            Positioned(
                right: 0,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  clipBehavior: Clip.none,
                  children: [
                    Image.asset(
                      hasFemale
                          ? 'gif/female_running_larger.gif'
                          : 'gif/male_running.gif',
                      width: width / 3 * 2,
                    ),
                    Positioned(
                      bottom: -24,
                      right: 24,
                      child: ClipOval(
                        child: Container(
                          height: 34,
                          width: 155,
                          color: black.withOpacity(0.1),
                        ),
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
