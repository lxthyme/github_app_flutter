import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:gsy_app/common/style/gsy_style.dart';
import 'package:gsy_app/common/utils/navigator_utils.dart';
import 'package:gsy_app/l10n/gen_l10n/app_localizations.dart';
import 'package:gsy_app/page/dynamic/dynamic_page.dart';
import 'package:gsy_app/page/login/login_page.dart';
import 'package:gsy_app/page/todo-page.dart';
import 'package:gsy_app/widget/gsy_tabbar_widget.dart';
import 'package:gsy_app/widget/gsy_title_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<DynamicPageState> dynamicKey = GlobalKey();

  _dialogExitApp(BuildContext context) async {
    if (Platform.isAndroid) {
      AndroidIntent intent = const AndroidIntent(
        action: 'android.intent.action.MAIN',
        category: "android.intent.category.HOME",
      );
      await intent.launch();
    }
  }

  _renderTab(icon, text) {
    return Tab(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 16,
          ),
          Text(text),
        ],
      ),
    );
  }

  // final GlobalKey<Dyna
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    List<Widget> tabs = [
      _renderTab(GSYICons.MAIN_DT, localization.home_dynamic),
      _renderTab(GSYICons.MAIN_QS, localization.home_trend),
      _renderTab(GSYICons.MAIN_MY, localization.home_my),
    ];
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        _dialogExitApp(context);
      },
      child: GSYTabBarWidget(
        drawer: const LoginPage(),
        type: TabType.bottom,
        tabItems: tabs,
        tabViews: [
          DynamicPage(key: dynamicKey),
          const TODOPage('Trend Page'),
          const TODOPage('My Page'),
        ],
        onDoublePress: (value) {
          switch (value) {
            case 0:
              dynamicKey.currentState?.scrollToTop();
              break;
            case 1:
              break;
            case 2:
              break;
          }
        },
        backgroundColor: GSYColors.primarySwatch,
        indicatorColor: GSYColors.white,
        title: GSYTitleBar(
          localization.app_name,
          iconData: GSYICons.MAIN_SEARCH,
          needRightLocalIcon: true,
          onRightIconPressed: (value) {
            NavigatorUtils.goSearchPage(context, value);
          },
        ),
      ),
    );
  }
}
