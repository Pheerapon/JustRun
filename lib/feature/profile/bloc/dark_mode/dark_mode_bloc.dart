import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_dark_mode.dart';

class DarkModeBloc extends Bloc<DarkModeEvent, DarkModeState> {
  DarkModeBloc() : super(DarkModeInitial());

  ThemeMode themeMode;

  @override
  Stream<DarkModeState> mapEventToState(
    DarkModeEvent event,
  ) async* {
    if (event is ChangeDarkMode) {
      try {
        yield DarkModeLoading();
        if (event.darkMode) {
          themeMode = ThemeMode.dark;
        } else {
          themeMode = ThemeMode.light;
        }
        yield DarkModeSuccess(darkMode: event.darkMode,themeMode: themeMode);
      } catch (e) {
        yield DarkModeFailure(error: e.toString());
      }
    }
  }
}
