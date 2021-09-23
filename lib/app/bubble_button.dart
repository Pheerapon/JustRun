import 'package:flutter/material.dart';
import 'package:flutter_habit_run/app/opacity_clicked.dart';
import 'package:spring/spring.dart';

class BubbleButton extends StatelessWidget {
  BubbleButton({this.child, this.animDuration, this.onTap});
  final Widget child;
  final Function onTap;
  final Duration animDuration;
  final SpringController springController = SpringController();
  @override
  Widget build(BuildContext context) {
    return OpacityClicked(child: GestureDetector(onTap: onTap, child: child));
  }
}
