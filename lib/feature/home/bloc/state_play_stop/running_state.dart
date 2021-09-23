import 'package:equatable/equatable.dart';

abstract class RunningState extends Equatable {
  const RunningState();
}

class RunningInitial extends RunningState {
  @override
  List<Object> get props => [];
}

class RunningLoading extends RunningState {
  @override
  List<Object> get props => [];
}

class RunningSuccess extends RunningState {
  const RunningSuccess({this.isStop});
  final bool isStop;
  @override
  List<Object> get props => [isStop];
}

class RunningFailure extends RunningState {
  const RunningFailure({this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
