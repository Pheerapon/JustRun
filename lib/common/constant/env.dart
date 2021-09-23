import 'dart:io';

mixin EnvValue {
  static const String policy = 'https://runner-habit.timistudio.dev/policy';
  static const String terms = 'https://runner-habit.timistudio.dev/terms';
  static const String adUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String databaseUrl =
      'https://justrun-79f4b-default-rtdb.firebaseio.com';
  static const String hasuraClaim = 'https://hasura.io/jwt/claims';
  static const String policyLocation =
      'This app collects location data to enable "Run feature", even when the app is not in used (background mode). This app will not collects data when the app is closed.';
}

class AdHelper {
  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    }
    throw UnsupportedError('Unsupported platform');
  }
}
