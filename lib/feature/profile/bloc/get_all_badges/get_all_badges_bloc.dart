import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_habit_run/common/model/badge_model.dart';

import 'bloc_get_all_badges.dart';

class GetAllBadgesBloc extends Bloc<GetAllBadgesEvent, GetAllBadgesState> {
  GetAllBadgesBloc() : super(GetAllBadgesInitial());

  @override
  Stream<GetAllBadgesState> mapEventToState(
    GetAllBadgesEvent event,
  ) async* {
    if (event is GetBadgesEvent) {
      final List<List<BadgeModel>> levelBadges = [];
      List<int> levelList = [];
      try {
        yield GetDataChartLoading();
        for (var element in event.allBadges) {
          levelList.add(element.level);
        }
        levelList = levelList.toSet().toList();
        levelList.sort();

        for (var i in levelList) {
          final List<BadgeModel> a = [];
          for (var element in event.allBadges) {
            if (element.level == i) {
              a.add(element);
            }
          }
          levelBadges.add(a);
        }
        yield GetAllBadgesSuccess(levelBadges: levelBadges);
      } catch (e) {
        yield GetAllBadgesFailure(error: e.toString());
      }
    }
  }
}
