import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/graphql/config.dart';
import 'package:flutter_habit_run/common/graphql/mutations.dart';
import 'package:flutter_habit_run/common/model/user_model.dart';
import 'package:flutter_habit_run/common/route/routes.dart';
import 'package:flutter_habit_run/common/util/format_time.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql/client.dart';

import '../bloc/save_info_user/save_info_user_bloc.dart';
import '../bloc/save_points_user/save_points_bloc.dart';
import '../widget/custom_google_map.dart';
import '../widget/home_widget.dart';
import 'home.dart';

class FinishRun extends StatefulWidget {
  const FinishRun({this.time, this.steps, this.distance});
  final int time;
  final int steps;
  final double distance;

  @override
  _FinishRunState createState() => _FinishRunState();
}

class _FinishRunState extends State<FinishRun> {
  ///param speed
  double avg;

  /// param point
  int point;

  /// declare params to screenshot map
  GoogleMapController mapController;
  String mapStyle;
  String mapStyleDark;

  /// handle polyLines show in google map
  Set<Polyline> polyLines = {};
  void setPolyLines() {
    final Polyline polyline = Polyline(
        polylineId: const PolylineId('route'),
        width: 4,
        color: redSalsa,
        points: BlocProvider.of<SavePointsBloc>(context).polyLine);
    polyLines.add(polyline);
  }

  Future<void> addHistory(BuildContext context, int point) async {
    AppWidget.showDialogCustom(context: context);

    ///screenshot map to save distance of user ran
    await mapController.takeSnapshot().then((value) async {
      final User user = FirebaseAuth.instance.currentUser;
      await user.getIdToken().then((token) async {
        await Config.initializeClient(token).value.mutate(MutationOptions(
                document: gql(Mutations.addHistory()),
                variables: <String, dynamic>{
                  'avg': avg.toInt(),
                  'date': '${DateTime.now().toString()}',
                  'distance': widget.distance,
                  'image': base64Encode(value),
                  'steps': widget.steps,
                  'time': FormatTime.convertTime(widget.time),
                  'money': point,
                  'user_id': user.uid
                }));
        Navigator.of(context).pop();
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.homeScreen, (route) => false,
            arguments: const HomeScreen(currentIndex: 0));
      });
    });
  }

  @override
  void initState() {
    DefaultAssetBundle.of(context)
        .loadString('images/style_map/style_map.json')
        .then((string) {
      mapStyle = string;
    });
    DefaultAssetBundle.of(context)
        .loadString('images/style_map/style_map_dark.json')
        .then((string) {
      mapStyleDark = string;
    });
    setPolyLines();
    avg = widget.time != 0 ? widget.distance * 1000 / (widget.time) : 0;
    point = (widget.distance * 100).toInt();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    mapController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = AppWidget.getWidthScreen(context);
    final height = AppWidget.getHeightScreen(context);
    final bool hasFemale =
        BlocProvider.of<SaveInfoUserBloc>(context).userModel.gender ==
            Gender.Female;
    final bool darkMode = Theme.of(context).brightness == Brightness.light;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: AppBar(
            elevation: 0,
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Image.asset(
                hasFemale ? 'gif/female_running.gif' : 'gif/male_running.gif',
                width: height / 203 * 30,
                height: height / 203 * 30,
              ),
            ),
            leading: FutureBuilder(
              future: HomeWidget.getCurrentLocation(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return IconButton(
                    icon: Icon(
                      Icons.cancel_outlined,
                      size: 20,
                      color: Theme.of(context).color8,
                    ),
                    onPressed: () async {
                      await addHistory(context, 0);
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
        body: Stack(
          children: [
            FutureBuilder(
              future: HomeWidget.getCurrentLocation(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return CustomGoogleMap(
                    zoom: 14,
                    polyLines: polyLines,
                    circles: const <Circle>{},
                    myLocationEnabled: false,
                    destination:
                        LatLng(snapshot.data.latitude, snapshot.data.longitude),
                    onMapCreated: (controller) {
                      mapController = controller;
                      if (darkMode) {
                        mapController.setMapStyle(mapStyle);
                      } else {
                        mapController.setMapStyle(mapStyleDark);
                      }
                    },
                  );
                }
                return const Center(
                    child: CupertinoActivityIndicator(
                  animating: true,
                ));
              },
            ),
            IgnorePointer(
              child: Container(
                width: width,
                height: height,
                decoration:
                    BoxDecoration(gradient: Theme.of(context).colorGoogle),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 34),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(
                          text:
                              'Today, ${FormatTime.formatTime(format: Format.dMy)} ',
                          style: AppWidget.simpleTextFieldStyle(
                              fontSize: 14,
                              height: 21,
                              color: Theme.of(context).color8),
                          children: [
                        TextSpan(
                            text: '(AVG: ${avg.toInt()}m/s)',
                            style: AppWidget.simpleTextFieldStyle(
                                fontSize: 14, height: 21, color: azure))
                      ])),
                  Padding(
                    padding: const EdgeInsets.only(top: 1, bottom: 39),
                    child: HomeWidget.createDistance(
                        context: context, amount: widget.distance, title: 'Km'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      HomeWidget.createGroupText(
                          context: context,
                          amount: widget.steps.toString(),
                          title: 'Step'),
                      HomeWidget.createGroupText(
                          context: context, title: 'Time'),
                    ],
                  ),
                  const Spacer(),
                  FutureBuilder(
                    future: HomeWidget.getCurrentLocation(),
                    builder: (context, snapshot) {
                      return AppWidget.typeButtonStartAction(
                          input: 'Get +$point Point',
                          onPressed: () {},
                          bgColor: grey500);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
