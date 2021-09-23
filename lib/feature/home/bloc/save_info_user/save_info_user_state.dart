import 'package:equatable/equatable.dart';
import 'package:flutter_habit_run/common/model/user_model.dart';

abstract class SaveInfoUserState extends Equatable {
  const SaveInfoUserState();
}

class SaveInfoUserInitial extends SaveInfoUserState {
  @override
  List<Object> get props => [];
}

class SaveInfoUserLoading extends SaveInfoUserState {
  @override
  List<Object> get props => [];
}

class SaveInfoUserSuccess extends SaveInfoUserState {
  const SaveInfoUserSuccess({this.userModel});
  final UserModel userModel;
  @override
  List<Object> get props => [userModel];
}

class SaveInfoUserFailure extends SaveInfoUserState {
  const SaveInfoUserFailure({this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
