import 'package:equatable/equatable.dart';
import 'package:flutter_habit_run/common/model/goal_model.dart';

abstract class SaveGoalEvent extends Equatable {
  const SaveGoalEvent();
  @override
  List<Object> get props => [];
}

class SaveGoal extends SaveGoalEvent {
  const SaveGoal({this.goalModel});
  final GoalModel goalModel;
  @override
  List<Object> get props => [goalModel];
}
