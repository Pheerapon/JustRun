import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/graphql/config.dart';
import 'package:flutter_habit_run/common/graphql/queries.dart';
import 'package:flutter_habit_run/common/model/run_history_model.dart';
import 'package:graphql/client.dart';

import '../widget/item_history.dart';

class RunHistory extends StatefulWidget {
  @override
  _RunHistoryState createState() => _RunHistoryState();
}

class _RunHistoryState extends State<RunHistory> {
  Future<List<RunHistoryModel>> getHistories() async {
    final List<RunHistoryModel> runHistories = [];
    final User user = FirebaseAuth.instance.currentUser;
    await user.getIdToken().then((token) async {
      await Config.initializeClient(token)
          .value
          .query(QueryOptions(
              document: gql(Queries.getHistories),
              variables: <String, dynamic>{
                'user_id': user.uid,
              }))
          .then((value) {
        for (Map<String, dynamic> runHistory in value.data['RunHistory']) {
          runHistories.add(RunHistoryModel.fromJson(runHistory));
        }
      });
    });
    return runHistories;
  }

  Widget createTitle({String title}) {
    return Text(
      title.toUpperCase(),
      style: AppWidget.boldTextFieldStyle(
          fontSize: 12, height: 18, color: ultramarineBlue),
    );
  }

  @override
  void initState() {
    getHistories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).color15,
      appBar:
          AppWidget.createSimpleAppBar(context: context, hasBackground: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'History',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 16),
                          child: Text(
                            'Track your activity daily, weekly, monthly',
                            style: AppWidget.simpleTextFieldStyle(
                                fontSize: 16,
                                height: 24,
                                color: Theme.of(context).color4),
                          ),
                        ),
                      ])),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).color13,
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Column(
                  children: [
                    Table(
                      children: [
                        TableRow(
                          children: [
                            createTitle(title: 'Day'),
                            createTitle(title: 'Distance'),
                            createTitle(title: 'Time'),
                            Center(child: createTitle(title: 'Route')),
                          ],
                        ),
                      ],
                    ),
                    FutureBuilder<List<RunHistoryModel>>(
                      future: getHistories(),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data.length,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            separatorBuilder: (context, index) {
                              return AppWidget.divider(context);
                            },
                            itemBuilder: (context, index) {
                              return ItemHistory(
                                runHistory: snapshot.data[index],
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: CupertinoActivityIndicator(
                              animating: true,
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
