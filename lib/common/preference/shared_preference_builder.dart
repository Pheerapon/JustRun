import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesBuilder<T> extends StatelessWidget {
  const SharedPreferencesBuilder({
    Key key,
    @required this.pref,
    @required this.builder,
  }) : super(key: key);
  final String pref;
  final AsyncWidgetBuilder<T> builder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
        future: _future(),
        builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
          return builder(context, snapshot);
        });
  }

  Future<T> _future() async {
    return (await SharedPreferences.getInstance()).get(pref);
  }
}

Future<String> getShared({String input = 'gender'}) async {
  final SharedPreferences shared = await SharedPreferences.getInstance();
  return shared.getString(input);
}

Future<bool> getValueBool({String input}) async {
  final SharedPreferences shared = await SharedPreferences.getInstance();
  return shared.getBool(input);
}

Future<void> setShared(bool value, String key) async {
  final SharedPreferences shared = await SharedPreferences.getInstance();
  shared.setBool('$key', value);
}