import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/common/graphql/config.dart';
import 'package:flutter_habit_run/common/graphql/mutations.dart';
import 'package:flutter_habit_run/common/model/daily_reward_model.dart';
import 'package:graphql/client.dart';
import 'bloc_get_reward_daily.dart';

class GetRewardDailyBloc
    extends Bloc<GetRewardDailyEvent, GetRewardDailyState> {
  GetRewardDailyBloc() : super(GetRewardDailyInitial());

  DailyRewardModel dailyRewardModel;
  bool showDialog = false;

  Future<void> updateDailyReward({String currentDaily}) async {
    final User user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      user.getIdToken().then((token) async {
        await Config.initializeClient(token).value.mutate(MutationOptions(
                document: gql(Mutations.updateRewardDaily()),
                variables: <String, dynamic>{
                  'user_id': user.uid,
                  'days_row': 0,
                  'current_daily': currentDaily
                }));
      });
    }
  }

  @override
  Stream<GetRewardDailyState> mapEventToState(
      GetRewardDailyEvent event) async* {
    DateTime currentDaily;
    DateTime now;
    if (event is SaveStateGetRewardDaily) {
      try {
        yield GetRewardDailyLoading();
        dailyRewardModel = event.dailyRewardModel;
        now = DateTime.now();
        currentDaily = DateTime.tryParse(dailyRewardModel.currentDaily);
        if (now.subtract(const Duration(days: 2)).isBefore(currentDaily)) {
          if (DateTime(now.year, now.month, now.day).isBefore(currentDaily)) {
            showDialog = false;
          } else {
            showDialog = true;
          }
        } else {
          await updateDailyReward(currentDaily: dailyRewardModel.currentDaily);
          showDialog = true;
          dailyRewardModel = DailyRewardModel(
              daysInRow: 0, currentDaily: dailyRewardModel.currentDaily);
        }
        yield GetRewardDailySuccess(dailyRewardModel: dailyRewardModel);
      } catch (e) {
        yield GetRewardDailyFailure(error: e.toString());
      }
    }
  }
}
