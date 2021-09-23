import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_habit_run/common/graphql/config.dart';
import 'package:flutter_habit_run/common/graphql/queries.dart';
import 'package:flutter_habit_run/common/model/run_history_model.dart';
import 'package:flutter_habit_run/common/model/user_model.dart';
import 'package:graphql/client.dart';

class ApiHelper {
  Future<UserModel> getInfoUser({List<RunHistoryModel> run7Histories}) async {
    UserModel userModel;
    final User user = FirebaseAuth.instance.currentUser;
    await user.getIdToken().then((token) async {
      await Config.initializeClient(token)
          .value
          .query(QueryOptions(
              document: gql(Queries.getInfoUser),
              variables: <String, dynamic>{'id': user.uid}))
          .then((value) {
        userModel = UserModel.fromJson(value.data['User'][0]);
      });
      await Config.initializeClient(token)
          .value
          .query(QueryOptions(
              document: gql(Queries.get7DaysHistories),
              variables: <String, dynamic>{
                'user_id': user.uid,
                'date': DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day - 7)
                    .toIso8601String()
              }))
          .then((value) {
        for (Map<String, dynamic> runHistory in value.data['RunHistory']) {
          run7Histories.add(RunHistoryModel.fromJson(runHistory));
        }
      });
    });
    return userModel;
  }
}
