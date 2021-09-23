import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/common/model/goal_model.dart';
import 'bloc_save_goal.dart';

class SaveGoalBloc extends Bloc<SaveGoalEvent, SaveGoalState> {
  SaveGoalBloc() : super(SaveGoalInitial());

  GoalModel goalModel;
  @override
  Stream<SaveGoalState> mapEventToState(SaveGoalEvent event) async* {
    if (event is SaveGoal) {
      try {
        yield SaveGoalLoading();
        goalModel = event.goalModel;
        yield SaveGoalSuccess(
          goalModel: event.goalModel,
        );
      } catch (e) {
        yield SaveGoalFailure(error: e.toString());
      }
    }
  }
}
