import 'package:equatable/equatable.dart';

abstract class RunningEvent extends Equatable {
  const RunningEvent();
}

class StopEvent extends RunningEvent {
  const StopEvent({this.isStop});
  final bool isStop;
  @override
  List<Object> get props => [isStop];
}
