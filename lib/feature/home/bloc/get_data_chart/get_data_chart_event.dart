import 'package:equatable/equatable.dart';
import 'package:flutter_habit_run/common/model/run_history_model.dart';

abstract class GetDataChartEvent extends Equatable {
  const GetDataChartEvent();
}

class GetDataEvent extends GetDataChartEvent {
  const GetDataEvent({this.runHistories});
  final List<RunHistoryModel> runHistories;
  @override
  List<Object> get props => [runHistories];
}
