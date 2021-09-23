import 'package:equatable/equatable.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();
}

class SetAlarmPressed extends NotificationsEvent {
  const SetAlarmPressed({this.minutes, this.hour}) : super();
  final String hour;
  final String minutes;

  @override
  List<Object> get props => [hour, minutes];

  @override
  String toString() => 'SetNotificationPressed { hour: $hour, minutes: $minutes }';
}
