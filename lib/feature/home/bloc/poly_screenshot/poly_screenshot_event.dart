import 'package:equatable/equatable.dart';

abstract class PolyScreenShotEvent extends Equatable {
  const PolyScreenShotEvent();
}

class GetScreenShot extends PolyScreenShotEvent {
  const GetScreenShot({this.bytes});
  final List<int> bytes;
  @override
  List<Object> get props => [bytes];
}
