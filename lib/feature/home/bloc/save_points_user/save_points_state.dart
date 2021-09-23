import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class SavePointsState extends Equatable {
  const SavePointsState();
}

class SavePointsInitial extends SavePointsState {
  @override
  List<Object> get props => [];
}

class SavePointsLoading extends SavePointsState {
  @override
  List<Object> get props => [];
}

class SavePointsSuccess extends SavePointsState {
  const SavePointsSuccess({this.polyLine});
  final List<LatLng> polyLine;
  @override
  List<Object> get props => [polyLine];
}

class SavePointsFailure extends SavePointsState {
  const SavePointsFailure({this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
