import 'package:equatable/equatable.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();
}

class NotificationsInitial extends NotificationsState {
  @override
  List<Object> get props => [];
}

class NotificationsLoading extends NotificationsState {
  @override
  List<Object> get props => [];
}

class NotificationsSuccess extends NotificationsState {
  @override
  List<Object> get props => [];
}

class NotificationsFailure extends NotificationsState {
  const NotificationsFailure({this.errorHour, this.errorMinutes});
  final String errorHour;
  final String errorMinutes;

  @override
  List<Object> get props => [errorHour, errorMinutes];
}
