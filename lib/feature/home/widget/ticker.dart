import 'package:flutter/cupertino.dart';

class Ticker {
  const Ticker();
  Stream<int> tick({@required int ticks}) {
    return Stream.periodic(const Duration(seconds: 1), (x) => ticks + x + 1);
  }
}
