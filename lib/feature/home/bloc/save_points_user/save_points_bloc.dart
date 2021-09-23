import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'bloc_save_points.dart';

class SavePointsBloc extends Bloc<SavePointsEvent, SavePointsState> {
  SavePointsBloc() : super(SavePointsInitial());

  List<LatLng> polyLine = [];

  @override
  Stream<SavePointsState> mapEventToState(SavePointsEvent event) async* {
    if (event is SavePointEvent) {
      try {
        yield SavePointsLoading();
        polyLine.add(event.position);
        yield SavePointsSuccess(polyLine: polyLine);
      } catch (e) {
        yield SavePointsFailure(error: e.toString());
      }
    }
  }
}
