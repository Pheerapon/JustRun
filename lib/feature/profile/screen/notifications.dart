import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import '../bloc/notifications/bloc_notifications.dart';
import '../widget/form_notification.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  TextEditingController hourController = TextEditingController();
  TextEditingController minutesController = TextEditingController();
  FocusNode hourNode = FocusNode();
  FocusNode minutesNode = FocusNode();
  NotificationsBloc notificationsBloc;

  Future<void> dialogSuccessed(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      AppWidget.customSnackBar(
        color: caribbeanGreen,
        content: 'Set up notification success',
      ),
    );
  }

  @override
  void didChangeDependencies() {
    notificationsBloc = BlocProvider.of<NotificationsBloc>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    hourController.dispose();
    minutesController.dispose();
    hourNode.dispose();
    minutesNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidget.createSimpleAppBar(context: context),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notification',
                style: Theme.of(context).textTheme.headline1,
              ),
              Text(
                'What time do you usually run?',
                style: AppWidget.simpleTextFieldStyle(
                    fontSize: 16, height: 24, color: Theme.of(context).color4),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: FormNotifications(
                          controller: hourController,
                          focusNode: hourNode,
                          type: TextFieldType.hour,
                          focusNext: minutesNode,
                          label: 'hour'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: Text(
                        ':',
                        style: AppWidget.simpleTextFieldStyle(
                            fontSize: 16,
                            height: 24,
                            color: Theme.of(context).color7),
                      ),
                    ),
                    Expanded(
                      child: FormNotifications(
                          controller: minutesController,
                          focusNode: minutesNode,
                          type: TextFieldType.minutes,
                          label: 'minutes'),
                    )
                  ],
                ),
              ),
              BlocBuilder<NotificationsBloc, NotificationsState>(
                builder: (context, state) {
                  if (state is NotificationsSuccess) {
                    dialogSuccessed(context);
                  }
                  return AppWidget.typeButtonStartAction(
                      input: 'Setup Notification',
                      bgColor: ultramarineBlue,
                      onPressed: () async {
                        notificationsBloc.add(SetAlarmPressed(
                            hour: hourController.text,
                            minutes: minutesController.text));
                      });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
