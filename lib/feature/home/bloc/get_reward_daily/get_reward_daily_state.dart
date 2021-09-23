import 'package:equatable/equatable.dart';
import 'package:flutter_habit_run/common/model/daily_reward_model.dart';

abstract class GetRewardDailyState extends Equatable {
  const GetRewardDailyState();
}

class GetRewardDailyInitial extends GetRewardDailyState {
  @override
  List<Object> get props => [];
}

class GetRewardDailyLoading extends GetRewardDailyState {
  @override
  List<Object> get props => [];
}

class GetRewardDailySuccess extends GetRewardDailyState {
  const GetRewardDailySuccess({this.dailyRewardModel});
  final DailyRewardModel dailyRewardModel;
  @override
  List<Object> get props => [dailyRewardModel];
}

class GetRewardDailyFailure extends GetRewardDailyState {
  const GetRewardDailyFailure({this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
