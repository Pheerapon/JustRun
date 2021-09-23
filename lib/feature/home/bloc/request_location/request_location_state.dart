import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

abstract class RequestLocationState extends Equatable {
  const RequestLocationState();
}

class RequestLocationInitial extends RequestLocationState {
  @override
  List<Object> get props => [];
}

class RequestLocationLoading extends RequestLocationState {
  @override
  List<Object> get props => [];
}

class RequestLocationSuccess extends RequestLocationState {
  const RequestLocationSuccess({this.position});
  final Position position;
  @override
  List<Object> get props => [position];
}

class RequestLocationFailure extends RequestLocationState {
  const RequestLocationFailure({this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
