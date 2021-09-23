import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_poly_screenshot.dart';

class PolyScreenShotBloc
    extends Bloc<PolyScreenShotEvent, PolyScreenShotState> {
  PolyScreenShotBloc() : super(PolyScreenShotInitial());

  @override
  Stream<PolyScreenShotState> mapEventToState(
      PolyScreenShotEvent event) async* {
    if (event is GetScreenShot) {
      try {
        yield PolyScreenShotLoading();
        yield PolyScreenShotSuccess(bytes: base64UrlEncode(event.bytes));
      } catch (e) {
        yield PolyScreenShotFailure(error: e.toString());
      }
    }
  }
}
