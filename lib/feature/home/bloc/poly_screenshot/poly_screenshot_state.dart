import 'package:equatable/equatable.dart';

abstract class PolyScreenShotState extends Equatable {
  const PolyScreenShotState();
}

class PolyScreenShotInitial extends PolyScreenShotState {
  @override
  List<Object> get props => [];
}

class PolyScreenShotLoading extends PolyScreenShotState {
  @override
  List<Object> get props => [];
}

class PolyScreenShotSuccess extends PolyScreenShotState {
  const PolyScreenShotSuccess({this.bytes});
  final String bytes;
  @override
  List<Object> get props => [bytes];
}

class PolyScreenShotFailure extends PolyScreenShotState {
  const PolyScreenShotFailure({this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
