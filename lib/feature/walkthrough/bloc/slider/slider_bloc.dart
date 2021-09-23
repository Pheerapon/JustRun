import 'package:bloc/bloc.dart';
import 'slider_event.dart';

class SliderBloc extends Bloc<SliderEvent, int> {
  SliderBloc() : super(0);

  @override
  Stream<int> mapEventToState(SliderEvent event) async* {
    switch (event) {
      case SliderEvent.swipeLeft:
        yield state - 1;
        break;
      case SliderEvent.swipeRight:
        yield state + 1;
        break;
    }
  }
}
