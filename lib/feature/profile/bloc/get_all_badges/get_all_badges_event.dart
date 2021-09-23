import 'package:equatable/equatable.dart';
import 'package:flutter_habit_run/common/model/badge_model.dart';

abstract class GetAllBadgesEvent extends Equatable {
  const GetAllBadgesEvent();
}

class GetBadgesEvent extends GetAllBadgesEvent {
  const GetBadgesEvent({this.allBadges});
  final List<BadgeModel> allBadges;
  @override
  List<Object> get props => [allBadges];
}
