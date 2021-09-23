import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/route/routes.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../bloc/request_location/bloc_request_location.dart';
import '../screen/count_down.dart';
import 'custom_google_map.dart';

class GoogleRunner extends StatelessWidget {
  const GoogleRunner({this.checkPolicyLocation, this.step});
  final Function checkPolicyLocation;
  final int step;
  @override
  Widget build(BuildContext context) {
    final width = AppWidget.getWidthScreen(context);
    Position position;
    return BlocBuilder<RequestLocationBloc, RequestLocationState>(
      builder: (context, state) {
        if (state is RequestLocationSuccess) {
          position = state.position;
        }
        return position != null
            ? Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        SizedBox(
                            width: width,
                            child: CustomGoogleMap(
                              zoom: 16,
                              position: position,
                              polyLines: const <Polyline>{},
                              circles: {
                                Circle(
                                    circleId: const CircleId('currentLocation'),
                                    center: LatLng(
                                        position.latitude, position.longitude),
                                    radius: 180,
                                    strokeWidth: 0,
                                    fillColor: ultramarineBlue.withOpacity(0.1))
                              },
                            )),
                        IgnorePointer(
                          child: Container(
                            width: width,
                            decoration: BoxDecoration(
                                gradient: Theme.of(context).colorGoogle),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: constraints.maxWidth * 0.6,
                              child: position != null
                                  ? AppWidget.typeButtonStartAction(
                                      input: 'Start',
                                      onPressed: () {
                                        if (Platform.isAndroid) {
                                          AwesomeNotifications()
                                              .isNotificationAllowed()
                                              .then((isAllowed) {
                                            if (!isAllowed) {
                                              AwesomeNotifications()
                                                  .requestPermissionToSendNotifications();
                                            } else {
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  Routes.countDown,
                                                  (route) => false,
                                                  arguments: CountDown(
                                                    oldStep: step ?? 0,
                                                  ));
                                            }
                                          });
                                        } else {
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              Routes.countDown,
                                              (route) => false,
                                              arguments: CountDown(
                                                oldStep: step ?? 0,
                                              ));
                                        }
                                      },
                                      bgColor: ultramarineBlue,
                                      vertical: 12)
                                  : AppWidget.typeButtonStartAction(
                                      input: 'Start',
                                      onPressed: () {},
                                      bgColor: grey500,
                                      vertical: 12),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    width: width * 0.6,
                    child: AppWidget.typeButtonStartAction(
                        onPressed: () {
                          Navigator.of(context).pushNamed(Routes.settingGoal);
                        },
                        input: 'Set a Goal',
                        bgColor: ultramarineBlue.withOpacity(0.1),
                        textColor: ultramarineBlue,
                        vertical: 12),
                  )
                ],
              )
            : Column(
                children: [
                  const Expanded(
                    child: CupertinoActivityIndicator(
                      animating: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: constraints.maxWidth * 0.6,
                              child: AppWidget.typeButtonStartAction(
                                  onPressed: () {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      checkPolicyLocation();
                                    });
                                  },
                                  input: 'Request Location',
                                  bgColor: ultramarineBlue,
                                  vertical: 12,
                                  horizontal: 16),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
      },
    );
  }
}
