import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPrivacy extends StatefulWidget {
  const WebViewPrivacy({this.url,this.title});
  final String url;
  final String title;
  @override
  _WebViewPrivacyState createState() => _WebViewPrivacyState();
}

class _WebViewPrivacyState extends State<WebViewPrivacy> {
  Future<String> get _url async {
    await Future<dynamic>.delayed(const Duration(seconds: 1));
    return widget.url;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidget.createSimpleAppBar(
          context: context, title: widget.title),
      body: FutureBuilder(
        future: _url,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return WebView(
              initialUrl: snapshot.data,
              javascriptMode: JavascriptMode.unrestricted,
            );
          }
          return const Center(
            child: CupertinoActivityIndicator(
              animating: true,
            ),
          );
        },
      ),
    );
  }
}
