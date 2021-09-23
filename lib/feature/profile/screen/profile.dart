import 'package:flutter/material.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import '../widget/my_badges.dart';
import '../widget/profile_item.dart';
import '../widget/sliver_app_bar_custom.dart';

class Profile extends StatefulWidget {
  Profile({this.userBadges});
  final List<int> userBadges;
  final List<Map<String, dynamic>> profileItem = [
    <String, dynamic>{
      'image': 'images/star@3x.png',
      'title': 'All Badges',
      'subtitle': 'See all badges you can get',
    },
    <String, dynamic>{
      'image': 'images/clock@3x.png',
      'title': 'History',
      'subtitle': 'Latest activity: ',
    },
    <String, dynamic>{
      'image': 'images/moon@3x.png',
      'title': 'Dark mode',
      'subtitle': 'Switch dark/light mode',
    },
  ];
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final height = AppWidget.getHeightScreen(context);
    final width = AppWidget.getWidthScreen(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(width, height / 58 * 15),
        child: SliverAppBarCustom(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                MyBadges(
                  userBadges: widget.userBadges,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: AppWidget.divider(context),
                ),
                ListView.separated(
                    shrinkWrap: true,
                    padding:
                        const EdgeInsets.only(bottom: 24, left: 32, right: 32),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ProfileItem(
                        item: widget.profileItem[index],
                        index: index,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return AppWidget.divider(context);
                    },
                    itemCount: widget.profileItem.length),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
