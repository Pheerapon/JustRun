import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/feature/profile/bloc/notifications/bloc_notifications.dart';

enum TextFieldType { hour, minutes }

class FormNotifications extends StatefulWidget {
  const FormNotifications(
      {Key key,
      this.controller,
      this.label,
      this.focusNode,
      this.focusNext,
      this.type})
      : super(key: key);
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode focusNext;
  final String label;
  final TextFieldType type;

  @override
  _FormNotificationsState createState() => _FormNotificationsState();
}

class _FormNotificationsState extends State<FormNotifications> {
  String _hourError;
  String _minutesError;

  UnderlineInputBorder createInputDecoration() {
    return UnderlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).color3));
  }

  Widget checkErrorText(String error) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            onFieldSubmitted: (term) {
              widget.focusNode.unfocus();
              FocusScope.of(context).requestFocus(widget.focusNext);
            },
            style: AppWidget.simpleTextFieldStyle(
                color: grey04, fontSize: 24, height: 32),
            decoration: InputDecoration(
              hintText: widget.label,
              hintStyle: AppWidget.simpleTextFieldStyle(
                  fontSize: 24, height: 32, color: grey04),
              focusedErrorBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: primary, width: 1)),
              errorBorder: createInputDecoration(),
              focusedBorder: createInputDecoration(),
              enabledBorder: createInputDecoration(),
            )),
        error != null
            ? Text(
                error,
                style: AppWidget.simpleTextFieldStyle(
                    fontSize: 12, height: 18, color: primary),
              )
            : const SizedBox()
      ],
    );
  }

  Widget createTextFieldError(TextFieldType type) {
    Widget child;
    switch (type) {
      case TextFieldType.hour:
        child = checkErrorText(_hourError);
        break;
      case TextFieldType.minutes:
        child = checkErrorText(_minutesError);
        break;
      default:
        child = checkErrorText(null);
        break;
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      cubit: BlocProvider.of<NotificationsBloc>(context),
      builder: (context, state) {
        if (state is NotificationsFailure) {
          _hourError = state.errorHour;
          _minutesError = state.errorMinutes;
        }
        if (state is NotificationsSuccess) {
          _hourError = null;
          _minutesError = null;
        }
        return createTextFieldError(widget.type);
      },
    );
  }
}
