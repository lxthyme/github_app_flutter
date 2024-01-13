import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gsy_app/common/config/config.dart';
import 'package:gsy_app/common/style/gsy_style.dart';
import 'package:gsy_app/redux/gsy_state.dart';
import 'package:gsy_app/redux/locale_redux.dart';
import 'package:gsy_app/redux/theme_redux.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef StringList = List<String>;

class CommonUtils {
  static const double MILLIS_LIMIT = 1000.0;

  static const double SECONDS_LIMIT = 60 * MILLIS_LIMIT;

  static const double MINUTES_LIMIT = 60 * SECONDS_LIMIT;

  static const double HOURS_LIMIT = 24 * MINUTES_LIMIT;

  static const double DAYS_LIMIT = 30 * HOURS_LIMIT;

  static Locale? curLocale;

  static getApplicationDocumentsPath() async {
    Directory appDir;
    if (Platform.isIOS) {
      appDir = await getApplicationDocumentsDirectory();
    } else {
      appDir = await getApplicationSupportDirectory();
    }

    String appDocPath = '${appDir.path}/gsygithubappflutter';
    Directory appPath = Directory(appDocPath);
    await appPath.create(recursive: true);
    return appPath.path;
  }

  static pushTheme(Store store, int index) {
    List<Color> colors = getThemeListColor();
    ThemeData themeData = getThemeData(colors[index]);
    store.dispatch(RefreshThemeDataAction(themeData));
  }

  static getThemeData(Color color) {
    return ThemeData(
      ///用来适配 Theme.of(context).primaryColorLight 和 primaryColorDark 的颜色变化，不设置可能会是默认蓝色
      primarySwatch: color as MaterialColor,

      /// Card 在 M3 下，会有 apply Overlay

      colorScheme: ColorScheme.fromSeed(
        seedColor: color,
        primary: color,

        brightness: Brightness.light,

        ///影响 card 的表色，因为 M3 下是  applySurfaceTint ，在 Material 里
        surfaceTint: Colors.transparent,
      ),

      /// 受到 iconThemeData.isConcrete 的印象，需要全参数才不会进入 fallback
      iconTheme: IconThemeData(
        size: 24.0,
        fill: 0.0,
        weight: 400.0,
        grade: 0.0,
        opticalSize: 48.0,
        color: Colors.white,
        opacity: 0.8,
      ),

      ///修改 FloatingActionButton的默认主题行为
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(foregroundColor: Colors.white, backgroundColor: color, shape: CircleBorder()),
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 24.0,
        ),
        backgroundColor: color,
        titleTextStyle: Typography.dense2021.titleLarge,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      // 如果需要去除对应的水波纹效果
      // splashFactory: NoSplash.splashFactory,
      // textButtonTheme: TextButtonThemeData(
      //   style: ButtonStyle(splashFactory: NoSplash.splashFactory),
      // ),
      // elevatedButtonTheme: ElevatedButtonThemeData(
      //   style: ButtonStyle(splashFactory: NoSplash.splashFactory),
      // ),
    );
  }

  static changeLocale(Store<GSYState> store, int index) {
    Locale? locale = store.state.platformLocale;
    debugPrint('-->locale: ${store.state.platformLocale}');

    switch (index) {
      case 1:
        locale = Locale('zh', 'CH');
        break;
      case 2:
        locale = Locale('en', 'US');
        break;
    }
    curLocale = locale;
    store.dispatch(RefreshLocaleAction(locale));
  }

  static List<Color> getThemeListColor() {
    return [
      GSYColors.primarySwatch,
      Colors.brown,
      Colors.blue,
      Colors.teal,
      Colors.amber,
      Colors.blueGrey,
      Colors.deepOrange,
    ];
  }

  static copy(String? data, BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    if (data != null) {
      Clipboard.setData(ClipboardData(text: data));
      Fluttertoast.showToast(msg: localization.option_share_copy_success);
    }
  }

  static launchOutURL(String? url, BuildContext context) async {
    final localization = AppLocalizations.of(context)!;
    if (url != null && await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      Fluttertoast.showToast(msg: '${localization.option_web_launcher_error}: $url');
    }
  }
}
