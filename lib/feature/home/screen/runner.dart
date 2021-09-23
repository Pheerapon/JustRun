import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/constant/env.dart';
import 'package:flutter_habit_run/common/util/format_time.dart';
import 'package:flutter_habit_run/feature/home/widget/google_runner.dart';
import 'package:flutter_habit_run/feature/home/widget/home_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:pedometer/pedometer.dart';
import '../bloc/get_data_chart/bloc_get_data_chart.dart';
import '../bloc/request_location/bloc_request_location.dart';

class Runner extends StatefulWidget {
  @override
  _RunnerState createState() => _RunnerState();
}

class _RunnerState extends State<Runner> with AutomaticKeepAliveClientMixin {
  List<List<int>> runHistory7Day = [];
  Stream<StepCount> _stepCountStream;
  Stream<PedestrianStatus> _pedestrianStatusStream;
  int step = 0;
  Location location = Location();
  RequestLocationBloc requestLocationBloc;

  void onStepCount(StepCount event) {
    setState(() {
      step = event.steps;
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
  }

  void onStepCountError(dynamic error) {
    print('onStepCountError: $error');
  }

  Future<void> initPlatformState() async {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream.listen(onPedestrianStatusChanged);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
    if (!mounted) {
      return;
    }
  }

  Future<void> checkPolicyLocation() async {
    await showDialog<dynamic>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: white,
          content: Text(
            EnvValue.policyLocation,
            style: AppWidget.simpleTextFieldStyle(
                fontSize: 18, height: 24, color: btnAppleID),
          ),
          actions: [
            AppWidget.typeButtonStartAction(
                input: 'OK',
                horizontal: 24,
                miniSizeHorizontal: 0,
                bgColor: ultramarineBlue,
                onPressed: () async {
                  Navigator.of(context).pop();
                  requestLocation();
                }),
          ],
        );
      },
    );
  }

  Future<void> requestLocation() async {
    PermissionStatus permission;
    permission = await location.requestPermission();
    if (permission == PermissionStatus.denied ||
        permission == PermissionStatus.deniedForever) {
      requestLocationBloc.add(const RequestEvent(position: null));
      return;
    }

    location.hasPermission().then((value) async {
      if (value != PermissionStatus.granted) {
        return;
      }
      final Position position = await HomeWidget.getCurrentLocation();
      requestLocationBloc.add(RequestEvent(position: position));
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    requestLocationBloc = BlocProvider.of<RequestLocationBloc>(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    initPlatformState().whenComplete(() async {
      if (Platform.isIOS || Platform.isMacOS) {
        await requestLocation();
      } else {
        await checkPolicyLocation();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Text(
          'Today, ${FormatTime.formatTime(format: Format.Mdy)}',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 30),
          child: BlocBuilder<GetDataChartBloc, GetDataChartState>(
            builder: (context, state) {
              if (state is GetDataChartSuccess) {
                runHistory7Day = state.runHistory7Day;
              }
              return RichText(
                text: TextSpan(
                  text: runHistory7Day.last.isNotEmpty
                      ? runHistory7Day.last
                          .reduce((value, element) => value + element)
                          .toString()
                      : '0',
                  style: AppWidget.boldTextFieldStyle(
                      fontSize: 32,
                      height: 37.5,
                      color: Theme.of(context).color10,
                      fontFamily: 'Futura',
                      fontStyle: FontStyle.italic),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Steps',
                        style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
              );
            },
          ),
        ),
        Expanded(
          child: GoogleRunner(
            step: step,
            checkPolicyLocation: checkPolicyLocation,
          ),
        ),
      ],
    );
  }
}
