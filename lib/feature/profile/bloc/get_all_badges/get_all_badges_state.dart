import 'package:equatable/equatable.dart';
import 'package:flutter_habit_run/common/model/badge_model.dart';

abstract class GetAllBadgesState extends Equatable {
  const GetAllBadgesState();
}

class GetAllBadgesInitial extends GetAllBadgesState {
  @override
  List<Object> get props => [];
}

class GetDataChartLoading extends GetAllBadgesState {
  @override
  List<Object> get props => [];
}

class GetAllBadgesSuccess extends GetAllBadgesState {
  const GetAllBadgesSuccess({this.levelBadges});
  final List<List<BadgeModel>> levelBadges;
  @override
  List<Object> get props => [levelBadges];
}

class GetAllBadgesFailure extends GetAllBadgesState {
  const GetAllBadgesFailure({this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
