import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';

import '../bloc/get_all_badges/bloc_get_all_badges.dart';
import '../widget/badges_level.dart';

class BadgeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidget.createSimpleAppBar(context: context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'List Badges',
                style: Theme.of(context).textTheme.headline1,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 16),
                child: Text(
                  'Collect as many badges as you can',
                  style: AppWidget.simpleTextFieldStyle(
                      fontSize: 16, height: 24, color: Theme.of(context).color4),
                ),
              ),
              BlocBuilder<GetAllBadgesBloc, GetAllBadgesState>(
                  builder: (context, state) {
                if (state is GetAllBadgesSuccess) {
                  return Column(
                    children: state.levelBadges.map((list) {
                      return BadgeLevel(list);
                    }).toList(),
                  );
                }
                if (state is GetAllBadgesFailure) {
                  return Center(child: Text(state.error));
                } else
                  return const SizedBox();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
