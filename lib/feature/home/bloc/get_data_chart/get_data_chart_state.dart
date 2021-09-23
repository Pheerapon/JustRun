import 'package:equatable/equatable.dart';

abstract class GetDataChartState extends Equatable {
  const GetDataChartState();
}

class GetDataChartInitial extends GetDataChartState {
  @override
  List<Object> get props => [];
}

class GetDataChartLoading extends GetDataChartState {
  @override
  List<Object> get props => [];
}

class GetDataChartSuccess extends GetDataChartState {
  const GetDataChartSuccess({this.runHistory7Day, this.steps});
  final List<List<int>> runHistory7Day;
  final List<Map<String, dynamic>> steps;
  @override
  List<Object> get props => [runHistory7Day, steps];
}

class GetDataChartFailure extends GetDataChartState {
  const GetDataChartFailure({this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
