import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gsy_app/page/gsy_webview.dart';
import 'package:gsy_app/widget/never_overscroll_indicator.dart';

class NavigatorUtils {
  static Future gotoLoginWebView(BuildContext context, String url, String? title) {
    return navigatorRouter(context, GSYWebView(url, title));
  }

  static navigatorRouter(BuildContext context, Widget widget) {
    return Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => pageContainer(widget, context),
      ),
    );
  }

  static Widget pageContainer(widget, BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: NeverOverScrollIndicator(
        child: widget,
        needOverload: false,
      ),
    );
  }
}
