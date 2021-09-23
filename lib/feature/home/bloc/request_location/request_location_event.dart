import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

abstract class RequestLocationEvent extends Equatable {
  const RequestLocationEvent();
}

class RequestEvent extends RequestLocationEvent {
  const RequestEvent({this.position});
  final Position position;
  @override
  List<Object> get props => [position];
}
