import 'package:equatable/equatable.dart';
import 'package:flutter_habit_run/common/model/goal_model.dart';

abstract class SaveGoalState extends Equatable {
  const SaveGoalState();
}

class SaveGoalInitial extends SaveGoalState {
  @override
  List<Object> get props => [];
}

class SaveGoalLoading extends SaveGoalState {
  @override
  List<Object> get props => [];
}

class SaveGoalSuccess extends SaveGoalState {
  const SaveGoalSuccess({this.goalModel});
  final GoalModel goalModel;
  @override
  List<Object> get props => [goalModel];
}

class SaveGoalFailure extends SaveGoalState {
  const SaveGoalFailure({this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
