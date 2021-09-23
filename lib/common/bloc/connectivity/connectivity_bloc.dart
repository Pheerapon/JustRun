import 'dart:async';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_connectivity.dart';
class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  ConnectivityBloc() : super(AppStarted());
  StreamSubscription subscription;
  @override
  Stream<Transition<ConnectivityEvent, ConnectivityState>> transformEvents(
      Stream<ConnectivityEvent> events,
      TransitionFunction<ConnectivityEvent, ConnectivityState> transitionFn,
      ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }
  @override
  Stream<ConnectivityState> mapEventToState(ConnectivityEvent event) async* {
    if (event is ListenConnection) {
      subscription = DataConnectionChecker().onStatusChange.listen((status) {
        add(ConnectionChanged(status == DataConnectionStatus.disconnected
            ? InternetUnAvailable()
            : InternetAvailable()));
      });
    }
    if (event is ConnectionChanged) {
      yield event.connection;
    }
  }
  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }
}