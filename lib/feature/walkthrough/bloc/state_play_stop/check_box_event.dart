import 'package:equatable/equatable.dart';

abstract class CheckBoxEvent extends Equatable {
  const CheckBoxEvent();
}

class CheckedEvent extends CheckBoxEvent {
  const CheckedEvent({this.isChecked});
  final bool isChecked;
  @override
  List<Object> get props => [isChecked];
}
