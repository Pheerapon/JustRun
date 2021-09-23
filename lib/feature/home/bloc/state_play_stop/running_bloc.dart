import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_running.dart';

class RunningBloc extends Bloc<RunningEvent, RunningState> {
  RunningBloc() : super(RunningInitial());

  @override
  Stream<RunningState> mapEventToState(RunningEvent event) async* {
    if (event is StopEvent) {
      try {
        yield RunningLoading();
        yield RunningSuccess(isStop: !event.isStop);
      } catch (e) {
        yield RunningFailure(error: e.toString());
      }
    }
  }
}
