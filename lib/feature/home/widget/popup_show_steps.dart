import 'package:flutter/material.dart';
import 'package:flutter_habit_run/app/opacity_clicked.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'home_widget.dart';
import 'triangle_painter.dart';

class PopupShowSteps extends StatefulWidget {
  const PopupShowSteps({this.steps, this.child});
  final int steps;
  final Widget child;
  @override
  _PopupShowStepsState createState() => _PopupShowStepsState();
}

class _PopupShowStepsState extends State<PopupShowSteps> {
  GlobalKey globalKey = GlobalKey();
  OverlayEntry overlayEntry;
  bool showStep = false;

  @override
  void dispose() {
    overlayEntry?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OpacityClicked(
      child: GestureDetector(
        onTap: () {
          setState(() {
            showStep = !showStep;
          });
          final RenderBox renderBox =
              globalKey.currentContext.findRenderObject();
          final Offset offset = renderBox.localToGlobal(Offset.zero);
          overlayEntry = OverlayEntry(
            builder: (context) => Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    overlayEntry?.remove();
                    setState(() {
                      showStep = !showStep;
                    });
                  },
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      black.withOpacity(0),
                      BlendMode.srcOut,
                    ),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: white,
                            backgroundBlendMode: BlendMode.dstOut,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: offset.dy + 10,
                  left: offset.dx - 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 32,
                        decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.05),
                                  offset: Offset(0, 4),
                                  blurRadius: 15)
                            ],
                            color: Theme.of(context).color13,
                            borderRadius: BorderRadius.circular(4)),
                        child: Container(
                          width: 56,
                          child: OpacityClicked(
                            child: GestureDetector(
                              onTap: () {
                                overlayEntry?.remove();
                                setState(() {
                                  showStep = !showStep;
                                });
                              },
                              child: Center(
                                child: Text(
                                  '${(widget.steps).toString().replaceAllMapped(HomeWidget.reg, HomeWidget.mathFunc)}',
                                  style: AppWidget.boldTextFieldStyle(
                                      fontSize: 14,
                                      height: 17.07,
                                      color: Theme.of(context).color7,
                                      fontFamily: 'Futura',
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      CustomPaint(
                          size: const Size(10, 5),
                          painter:
                              TrianglePainter(color: Theme.of(context).color13)),
                    ],
                  ),
                )
              ],
            ),
          );
          Overlay.of(context).insert(overlayEntry);
        },
        child: SizedBox(
          key: globalKey,
          child: widget.child,
        ),
      ),
    );
  }
}
