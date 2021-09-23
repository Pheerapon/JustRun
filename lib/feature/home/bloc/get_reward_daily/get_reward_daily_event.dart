import 'package:equatable/equatable.dart';
import 'package:flutter_habit_run/common/model/daily_reward_model.dart';

abstract class GetRewardDailyEvent extends Equatable {
  const GetRewardDailyEvent();
}

class SaveStateGetRewardDaily extends GetRewardDailyEvent {
  const SaveStateGetRewardDaily({this.dailyRewardModel});
  final DailyRewardModel dailyRewardModel;
  @override
  List<Object> get props => [dailyRewardModel];
}
