import 'package:home_widget/home_widget.dart';

Future<void> updateHomeWidget(
    String date, String distance, int progress) async {
  await HomeWidget.saveWidgetData<String>('date', date);
  await HomeWidget.saveWidgetData<String>('distance', distance);
  await HomeWidget.saveWidgetData<int>('progress', progress);
  HomeWidget.updateWidget(
    name: 'RunWidgetProvider',
    androidName: 'RunWidgetProvider',
    iOSName: 'RunWidgetProvider',
  );
}
