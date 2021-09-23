import 'package:equatable/equatable.dart';

abstract class CheckBoxState extends Equatable {
  const CheckBoxState();
}

class CheckBoxInitial extends CheckBoxState {
  @override
  List<Object> get props => [];
}

class CheckBoxLoading extends CheckBoxState {
  @override
  List<Object> get props => [];
}

class CheckBoxSuccess extends CheckBoxState {
  const CheckBoxSuccess({this.isChecked});
  final bool isChecked;
  @override
  List<Object> get props => [isChecked];
}

class CheckBoxFailure extends CheckBoxState {
  const CheckBoxFailure({this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
