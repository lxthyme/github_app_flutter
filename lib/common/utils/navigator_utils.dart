import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gsy_app/model/CommonListDataType.dart';
import 'package:gsy_app/page/gsy_webview.dart';
import 'package:gsy_app/page/home/home_page.dart';
import 'package:gsy_app/page/login/login_page.dart';
import 'package:gsy_app/page/login/login_webview.dart';
import 'package:gsy_app/page/todo-page.dart';
import 'package:gsy_app/page/user/person_page.dart';
import 'package:gsy_app/router.dart';
import 'package:gsy_app/widget/never_overscroll_indicator.dart';

class NavigatorUtils {
  static pushNamed(BuildContext context, String routeName) {
    debugPrint('-->[router]pushNamed: $routeName');
    Navigator.pushNamed(context, routeName);
  }

  static goHome(BuildContext context) {
    debugPrint('-->[router]goHome: ${RouterName.home}');
    Navigator.pushReplacementNamed(context, RouterName.home);
  }

  static goLogin(BuildContext context) {
    debugPrint('-->[router]goLogin: ${RouterName.login}');
    Navigator.pushReplacementNamed(context, RouterName.login);
  }

  static gotoPhotoViewPage(BuildContext context, String? url) {
    debugPrint('-->[router]gotoPhotoViewPage: $url');
    // Navigator.pushNamed(context, const TODOPage('gotoPhotoViewPage'));
    navigatorRouter(context, const TODOPage('gotoPhotoViewPage'));
  }

  static goPerson(BuildContext context, String? userName) {
    navigatorRouter(context, PersonPage(userName));
  }

  static goDebugDataPage(BuildContext context) {
    return navigatorRouter(context, const TODOPage('goDebugDataPage'));
  }

  static gotoCommonList(
    BuildContext context,
    String? title,
    String showType,
    CommonListDataType dataType, {
    String? userName,
    String? reposName,
  }) {
    navigatorRouter(context, TODOPage('NotifyPage: ${{title, showType, dataType, userName, reposName}}'));
  }

  static Future goNotifyPage(BuildContext context) {
    return navigatorRouter(context, const TODOPage('NotifyPage'));
  }

  static Future goReposDetail(BuildContext context, String? userName, String? reposName) {
    debugPrint('-->[router]goReposDetail: $userName > $reposName');
    return Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => Container(
            child: const Center(
              child: Text('RepositoryDetailPage(userName, reposName)'),
            ),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            double begin = 0;
            double end = 1;
            var curve = Curves.ease;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return Align(
              child: SizeTransition(
                sizeFactor: animation.drive(tween),
                child: NeverOverScrollIndicator(
                  needOverload: false,
                  child: child,
                ),
              ),
            );
          },
        ));
  }

  static Future goHonorListPage(BuildContext context, List? list) {
    return Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const TODOPage('HonorListPage(list)'),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            double begin = 0;
            double end = 1;
            var curve = Curves.ease;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return Align(
              child: SizeTransition(
                sizeFactor: animation.drive(tween),
                child: NeverOverScrollIndicator(
                  needOverload: false,
                  child: child,
                ),
              ),
            );
          },
        ));
  }

  static Future goIssueDetail(BuildContext context, String? userName, String? reposName, String num,
      {bool needRightLocalIcon = false}) {
    return navigatorRouter(
      context,
      const Center(
        child: Text('IssueDetailPage'),
      ),
    );
  }

  static Future goPushDetailPage(
      BuildContext context, String? userName, String? reposName, String? sha, bool needHomeIcon) {
    return navigatorRouter(
      context,
      const Center(
        child: Text('PushDetailPage'),
      ),
    );
  }

  static Future gotoGSYWebView(BuildContext context, String url, String? title) {
    return navigatorRouter(context, GSYWebView(url, title));
  }

  static Future gotoLoginWebView(BuildContext context, String url, String title) {
    return navigatorRouter(context, LoginWebView(url, title));
  }

  static navigatorRouter(BuildContext context, Widget widget) {
    debugPrint('-->[router]navigatorRouter: ${widget.runtimeType}');
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

  static Future<T?> showGSYDialog<T>({
    required BuildContext context,
    bool barrierDismissible = true,
    WidgetBuilder? builder,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return MediaQuery(
            data: MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first)
                .copyWith(textScaler: TextScaler.noScaling),
            child: NeverOverScrollIndicator(
              needOverload: false,
              child: SafeArea(child: builder!(context)),
            ));
      },
    );
  }
}
