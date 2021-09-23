import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/create_notify.dart';

import 'notifications_event.dart';
import 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc() : super(NotificationsInitial());

  @override
  Stream<NotificationsState> mapEventToState(NotificationsEvent event) async* {
    if (event is SetAlarmPressed) {
      try {
        yield NotificationsLoading();
        if (_hourError(event.hour) == null &&
            _minutesError(event.minutes) == null) {
          CreateNotify().scheduleNotification(
              int.tryParse(event.hour), int.tryParse(event.minutes));
          yield NotificationsSuccess();
        }
        if (_hourError(event.hour) != null ||
            _minutesError(event.minutes) != null) {
          yield NotificationsFailure(
              errorHour: _hourError(event.hour),
              errorMinutes: _minutesError(event.minutes));
        }
      } catch (error) {
        yield NotificationsFailure(
            errorHour: error.toString(), errorMinutes: error.toString());
      }
    }
  }

  String _hourError(String hourString) {
    if (hourString.isEmpty) {
      return "Hour can't empty";
    } else {
      final int hour = int.tryParse(hourString);
      if (hour == null) {
        return 'Hour invalid';
      } else if (hour >= 24 || hour < 0) {
        return 'Hour only take value from 0 to 23';
      } else {
        return null;
      }
    }
  }

  String _minutesError(String minutesString) {
    if (minutesString.isEmpty) {
      return "Minutes can't empty";
    } else {
      final int minutes = int.tryParse(minutesString);
      if (minutes == null) {
        return 'Minutes invalid';
      } else if (minutes >= 60 || minutes < 0) {
        return 'Minutes only take value from 0 to 59';
      } else {
        return null;
      }
    }
  }
}
