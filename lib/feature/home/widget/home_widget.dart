import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/util/format_time.dart';
import 'package:geolocator/geolocator.dart';

import 'count_time.dart';

mixin HomeWidget {
  /// add commas to String number
  static final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  static final Function mathFunc = (Match match) => '${match[1]},';

  static BottomNavigationBarItem createItemNav(
      {BuildContext context, String pathIcon, String label}) {
    return BottomNavigationBarItem(
        activeIcon: createIcon(pathIcon: pathIcon, color: ultramarineBlue),
        icon: createIcon(pathIcon: pathIcon, color: Theme.of(context).color4),
        label: label);
  }

  static Widget createIcon({String pathIcon, Color color}) {
    return Image.asset(
      pathIcon,
      width: 24,
      height: 24,
      color: color,
    );
  }

  static Widget createBtnIcon(
    Color color, {
    String icon,
    double size = 40,
    double radius = 16,
    Widget child,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(radius)),
      child: child ??
          Image.asset(
            icon,
            color: white,
            width: 24,
            height: 24,
          ),
    );
  }

  static Widget createDistance(
      {BuildContext context,
      bool hasCamera = false,
      double amount,
      String title}) {
    return Row(
      children: [
        Text(
          '${amount.toStringAsFixed(2)}',
          style: AppWidget.boldTextFieldStyle(
              fontSize: 56,
              height: 65.63,
              color: hasCamera ? grey1100 : Theme.of(context).color10,
              fontFamily: 'Futura',
              fontStyle: FontStyle.italic),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Text(
            title,
            style: AppWidget.boldTextFieldStyle(
                fontSize: 18,
                height: 28,
                color: hasCamera ? grey1100 : Theme.of(context).color4),
          ),
        ),
      ],
    );
  }

  static Widget createGroupText(
      {BuildContext context,
      bool hasCamera = false,
      String amount,
      String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        amount != null
            ? Text(amount,
                style: AppWidget.boldTextFieldStyle(
                    fontSize: 32,
                    height: 37.5,
                    color: hasCamera ? grey1100 : Theme.of(context).color10,
                    fontFamily: 'Futura',
                    fontStyle: FontStyle.italic))
            : TimerText(),
        Text(
          title,
          style: AppWidget.boldTextFieldStyle(
              fontSize: 18,
              height: 28,
              color: hasCamera ? grey1100 : Theme.of(context).color4),
        ),
      ],
    );
  }

  static Future<Position> getCurrentLocation() async {
    final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  static Widget money({BuildContext context, String amount}) {
    return Text(
      amount,
      style: AppWidget.simpleTextFieldStyle(
          color: Theme.of(context).color11,
          fontSize: 16,
          height: 24,
          fontFamily: 'FugazOne'),
    );
  }

  static Future<void> createNotification(
      {int currentTime,
      int newStep,
      AwesomeNotifications awesomeNotifications}) async {
    await awesomeNotifications.createNotification(
        content: NotificationContent(
      id: 1,
      channelKey: 'Steps',
      title: '''<ul>
          <li>${Emojis.person_symbol_footprints} $newStep steps</li>
          <li>   </li>
          <li>${Emojis.time_stopwatch} ${FormatTime.convertTime(currentTime)} time</li>
          <li>   </li>
          <li>${Emojis.person_activity_person_running} ${(newStep * 78 / 100000).toStringAsFixed(2)} km</li>
        </ul>''',
      notificationLayout: NotificationLayout.ProgressBar,
      displayOnForeground: true,
      displayOnBackground: true,
      autoCancel: false,
      displayedLifeCycle: NotificationLifeCycle.AppKilled,
      progress: (newStep / 3000 * 100).toInt(),
    ));
  }
}
