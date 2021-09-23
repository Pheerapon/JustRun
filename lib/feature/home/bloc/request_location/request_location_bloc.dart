import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_request_location.dart';

class RequestLocationBloc
    extends Bloc<RequestLocationEvent, RequestLocationState> {
  RequestLocationBloc() : super(RequestLocationInitial());

  @override
  Stream<RequestLocationState> mapEventToState(
      RequestLocationEvent event) async* {
    if (event is RequestEvent) {
      try {
        yield RequestLocationLoading();
        yield RequestLocationSuccess(position: event.position);
      } catch (e) {
        yield RequestLocationFailure(error: e.toString());
      }
    }
  }
}
