import 'package:equatable/equatable.dart';
import 'connectivity_state.dart';
abstract class ConnectivityEvent extends Equatable {
  @override
  List<Object> get props => [];
}
class ListenConnection extends ConnectivityEvent {}
class ConnectionChanged extends ConnectivityEvent {
  ConnectionChanged(this.connection);
  final ConnectivityState connection;
  @override
  List<Object> get props => [connection];
}