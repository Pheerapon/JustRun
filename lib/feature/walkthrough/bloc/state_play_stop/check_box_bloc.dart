import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_check_box.dart';

class CheckBoxBloc extends Bloc<CheckBoxEvent, CheckBoxState> {
  CheckBoxBloc() : super(CheckBoxInitial());

  @override
  Stream<CheckBoxState> mapEventToState(CheckBoxEvent event) async* {
    if (event is CheckedEvent) {
      try {
        yield CheckBoxLoading();
        yield CheckBoxSuccess(isChecked: !event.isChecked);
      } catch (e) {
        yield CheckBoxFailure(error: e.toString());
      }
    }
  }
}
