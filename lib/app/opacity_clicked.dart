import 'package:flutter/material.dart';
import 'package:flutter_habit_run/app/widget_support.dart';

class OpacityClicked extends StatefulWidget {
  const OpacityClicked(
      {this.route,
      this.input,
      this.fontSize,
      this.height,
      this.color,
      this.hasPop = false,
      this.child});
  final String route;
  final String input;
  final Color color;
  final double fontSize;
  final double height;
  final Widget child;
  final bool hasPop;
  @override
  _OpacityClickedState createState() => _OpacityClickedState();
}

class _OpacityClickedState extends State<OpacityClicked> {
  double opacity = 1.0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        opacity = 0.4;
        setState(() {});
      },
      onTapCancel: () {
        opacity = 1.0;
        setState(() {});
      },
      onTap: widget.hasPop
          ? () {
              Navigator.of(context).pop();
            }
          : () {
              widget.route != null
                  ? Navigator.of(context).pushNamed(widget.route)
                  : print('');
              opacity = 1.0;
              setState(() {});
            },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: opacity,
        child: widget.child ??
            Text(
              widget.input,
              style: AppWidget.simpleTextFieldStyle(
                  color: widget.color,
                  fontSize: widget.fontSize,
                  height: widget.height),
            ),
      ),
    );
  }
}
