import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/graphql/config.dart';
import 'package:flutter_habit_run/common/graphql/queries.dart';
import 'package:flutter_habit_run/common/model/badge_model.dart';
import 'package:graphql/client.dart';

import '../bloc/get_all_badges/bloc_get_all_badges.dart';
import 'badges_item.dart';

class MyBadges extends StatefulWidget {
  const MyBadges({this.userBadges});
  final List<int> userBadges;
  @override
  _MyBadgesState createState() => _MyBadgesState();
}

class _MyBadgesState extends State<MyBadges>
    with SingleTickerProviderStateMixin {
  bool showMyBadges = false;
  AnimationController _controller;
  Animation<double> _animation;
  List<BadgeModel> userBadges = [];
  GetAllBadgesBloc getAllBadgesBloc;

  Future<List<BadgeModel>> getAllBadge() async {
    final List<BadgeModel> allBadges = [];
    final User user = FirebaseAuth.instance.currentUser;
    await user.getIdToken().then((token) async {
      await Config.initializeClient(token)
          .value
          .query(QueryOptions(
            document: gql(Queries.getAllBadges),
          ))
          .then((value) {
        for (Map<String, dynamic> element in value.data['Badges']) {
          allBadges.add(BadgeModel.fromJson(element));
        }
        getAllBadgesBloc.add(GetBadgesEvent(allBadges: allBadges));
        for (var i in widget.userBadges) {
          allBadges[allBadges.indexWhere((element) => element.id == i)]
              .acquired = true;
        }
      });
    });
    return allBadges;
  }

  void onMyBadges() {
    setState(() {
      showMyBadges = !showMyBadges;
      if (showMyBadges) {
        _controller.forward();
      } else
        _controller.reverse();
    });
  }

  @override
  void didChangeDependencies() {
    getAllBadgesBloc = BlocProvider.of<GetAllBadgesBloc>(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    getAllBadge();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = AppWidget.getWidthScreen(context);
    final height = AppWidget.getHeightScreen(context);
    final int amountMyBadges =
        widget.userBadges != null ? widget.userBadges.length : 0;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: GestureDetector(
            onTap: onMyBadges,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: Image.asset(
                    'images/award@3x.png',
                    width: 32,
                    height: 32,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Badges',
                          style: AppWidget.boldTextFieldStyle(
                              fontSize: 18,
                              height: 28,
                              color: Theme.of(context).color8)),
                      Text(
                        ' $amountMyBadges badge(s) this year',
                        style: AppWidget.simpleTextFieldStyle(
                            fontSize: 14, height: 21, color: grey600),
                      ),
                    ],
                  ),
                ),
                RotationTransition(
                  turns: Tween(begin: 0.0, end: 0.25).animate(_controller),
                  child: Image.asset(
                    'images/arrow-right@3x.png',
                    width: 24,
                    height: 24,
                    color: Theme.of(context).color14,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _animation,
          child: SizedBox(
            height: height / 203 * 35,
            width: width,
            child: FutureBuilder<dynamic>(
              future: getAllBadge(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return const Center(
                      child: CupertinoActivityIndicator(
                        animating: true,
                      ),
                    );
                  case ConnectionState.done:
                    if (snapshot.data != null && widget.userBadges.isNotEmpty) {
                      return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: snapshot.data.length,
                          padding: const EdgeInsets.only(top: 20),
                          separatorBuilder: (context, index) {
                            return const SizedBox();
                          },
                          itemBuilder: (context, index) {
                            if (snapshot.data[index].acquired) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: BadgeItem(snapshot.data[index]),
                              );
                            } else
                              return const SizedBox();
                          });
                    } else {
                      return const Center(
                        child: Text('Go Run to achieve your first badge'),
                      );
                    }
                }
                return null;
              },
            ),
          ),
        )
      ],
    );
  }
}
