import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/feature/home/widget/home_widget.dart';
import 'package:gallery_saver/gallery_saver.dart';

import '../../../main.dart';

class Camera extends StatefulWidget {
  const Camera({this.distance, this.steps, this.time});
  final double distance;
  final String time;
  final int steps;
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  GlobalKey globalKey = GlobalKey();
  CameraController controller;
  String imagePath;
  Future<void> _initializeControllerFuture;
  int selectedCamera = 0;

  Future<void> screenShot() async {
    final RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();
    final image = await boundary.toImage();
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final pngBytes = byteData.buffer.asUint8List();
    final File imgFile = File(imagePath);
    await imgFile.writeAsBytes(pngBytes).whenComplete(() {
      GallerySaver.saveImage(imgFile.path, albumName: 'RunnerHabit');
    });
  }

  Widget createWidgetVisible({Widget child}) {
    return Visibility(child: child, visible: imagePath == null ? false : true);
  }

  @override
  void initState() {
    controller =
        CameraController(cameras[selectedCamera], ResolutionPreset.max);
    _initializeControllerFuture = controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = AppWidget.getWidthScreen(context);
    final height = AppWidget.getHeightScreen(context);
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            body: Stack(
              children: [
                RepaintBoundary(
                  key: globalKey,
                  child: Stack(
                    children: [
                      imagePath == null
                          ? SizedBox(
                              width: width,
                              height: height,
                              child: CameraPreview(controller))
                          : Image.file(File(imagePath),
                              width: width, height: height, fit: BoxFit.cover),
                      createWidgetVisible(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: FractionalOffset.topCenter,
                              end: FractionalOffset.bottomCenter,
                              colors: [
                                Color.fromRGBO(255, 255, 255, 0),
                                Color.fromRGBO(255, 255, 255, 0.6),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 56,
                          left: 36,
                          child: createWidgetVisible(
                              child: Image.asset('images/logo@1x.png',
                                  height: 40))),
                      Positioned(
                          bottom: 25,
                          left: 36,
                          child: createWidgetVisible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HomeWidget.createDistance(
                                    hasCamera: true,
                                    context: context,
                                    amount: widget.distance,
                                    title: 'Km'),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 32, bottom: 24),
                                    child: HomeWidget.createGroupText(
                                        hasCamera: true,
                                        context: context,
                                        amount: '${widget.steps}',
                                        title: 'Step')),
                                HomeWidget.createGroupText(
                                    hasCamera: true,
                                    context: context,
                                    amount: widget.time,
                                    title: 'Time')
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
                Positioned(
                    top: 50,
                    right: 16,
                    child: createWidgetVisible(
                      child: IconButton(
                          icon: Icon(
                            Icons.cancel_outlined,
                            size: 24,
                            color: white,
                          ),
                          onPressed: () {
                            screenShot();
                            Navigator.of(context).pop();
                          }),
                    )),
              ],
            ),
            floatingActionButton: imagePath == null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await controller.takePicture().then((value) {
                            setState(() {
                              imagePath = value.path;
                            });
                          });
                        },
                        child: HomeWidget.createBtnIcon(azure,
                            size: 60,
                            radius: 99,
                            child: Icon(
                              Icons.photo_camera_outlined,
                              size: 24,
                              color: white,
                              semanticLabel: 'Take a photo',
                            )),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCamera = selectedCamera == 0 ? 1 : 0;
                          });
                          controller = CameraController(
                            cameras[selectedCamera],
                            ResolutionPreset.max,
                          );
                          _initializeControllerFuture = controller.initialize();
                        },
                        child: HomeWidget.createBtnIcon(redSalsa,
                            size: 60,
                            radius: 99,
                            child: Icon(Icons.rotate_left_outlined,
                                size: 24, color: white)),
                      ),
                    ],
                  )
                : const SizedBox(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        }
        return const Scaffold(
          body: Center(
              child: CupertinoActivityIndicator(
            animating: true,
          )),
        );
      },
    );
  }
}
