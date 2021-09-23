import 'package:equatable/equatable.dart';
import 'package:flutter_habit_run/common/model/user_model.dart';

abstract class SaveInfoUserEvent extends Equatable {
  const SaveInfoUserEvent();
}

class SaveInfoEvent extends SaveInfoUserEvent {
  const SaveInfoEvent({this.userModel});
  final UserModel userModel;
  @override
  List<Object> get props => [userModel];
}
