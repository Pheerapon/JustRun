import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/common/model/user_model.dart';
import 'bloc_save_info_user.dart';

class SaveInfoUserBloc extends Bloc<SaveInfoUserEvent, SaveInfoUserState> {
  SaveInfoUserBloc() : super(SaveInfoUserInitial());

  UserModel userModel;
  @override
  Stream<SaveInfoUserState> mapEventToState(SaveInfoUserEvent event) async* {
    if (event is SaveInfoEvent) {
      try {
        yield SaveInfoUserLoading();
        userModel = event.userModel;
        yield SaveInfoUserSuccess(
          userModel: event.userModel,
        );
      } catch (e) {
        yield SaveInfoUserFailure(error: e.toString());
      }
    }
  }
}
