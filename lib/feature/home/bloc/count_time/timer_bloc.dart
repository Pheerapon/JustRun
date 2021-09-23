import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_habit_run/feature/home/widget/ticker.dart';

import 'bloc_timer.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc() : super(const TimerInitial(_duration));

  static const int _duration = 0;

  StreamSubscription<int> _tickerSubscription;

  @override
  Stream<TimerState> mapEventToState(
    TimerEvent event,
  ) async* {
    if (event is TimerStarted) {
      yield TimerRunInProgress(event.duration);
      _tickerSubscription = const Ticker()
          .tick(ticks: event.duration)
          .listen((duration) => add(TimerTicked(duration: duration)));
    } else if (event is TimerPaused) {
      _tickerSubscription.pause();
      yield TimerRunPause(state.duration);
    } else if (event is TimerResumed) {
      _tickerSubscription.resume();
      yield TimerRunInProgress(state.duration);
    } else if (event is TimerStop) {
      _tickerSubscription.cancel();
      yield TimerStopped(state.duration);
    } else if (event is TimerTicked) {
      yield TimerRunInProgress(event.duration);
    }
  }

  @override
  Future<void> close() {
    _tickerSubscription.cancel();
    return super.close();
  }
}
