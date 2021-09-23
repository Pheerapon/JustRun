import 'package:equatable/equatable.dart';

abstract class DarkModeEvent extends Equatable {
  const DarkModeEvent();
}

class ChangeDarkMode extends DarkModeEvent {
  const ChangeDarkMode({this.darkMode});
  final bool darkMode;
  @override
  List<Object> get props => [darkMode];
}
