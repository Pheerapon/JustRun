import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class SavePointsEvent extends Equatable {
  const SavePointsEvent();
}

class SavePointEvent extends SavePointsEvent {
  const SavePointEvent({this.position});
  final LatLng position;
  @override
  List<Object> get props => [position];
}
