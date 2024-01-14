import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gsy_app/common/config/config.dart';
import 'package:gsy_app/common/net/address.dart';
import 'package:gsy_app/common/style/gsy_style.dart';
import 'package:gsy_app/common/utils/navigator_utils.dart';
import 'package:gsy_app/redux/gsy_state.dart';
import 'package:gsy_app/redux/locale_redux.dart';
import 'package:gsy_app/redux/theme_redux.dart';
import 'package:gsy_app/widget/gsy_flex_button.dart';
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

  static String getDateStr(DateTime? dateTime) {
    if (dateTime == null || dateTime.toString() == '') {
      return '';
    } else if (dateTime.toString().length < 10) {
      return dateTime.toString();
    }
    return dateTime.toString().substring(0, 10);
  }

  static String getUserChartAddress(String userName) {
    var host = Address.graphicHost;
    var color = GSYColors.primaryDarkValueString.replaceAll('#', '');
    return '$host$color/$userName';
  }

  ///日期格式转换
  static String getNewsTimeStr(DateTime date) {
    int subTimes = DateTime.now().millisecondsSinceEpoch - date.millisecondsSinceEpoch;
    return switch (subTimes) {
      < MILLIS_LIMIT => (curLocale != null)
          ? (curLocale!.languageCode != "zh")
              ? "right now"
              : "刚刚"
          : "刚刚",
      < SECONDS_LIMIT => (subTimes / MILLIS_LIMIT).round().toString() +
          ((curLocale != null)
              ? (curLocale!.languageCode != "zh")
                  ? " seconds ago"
                  : " 秒前"
              : " 秒前"),
      < MINUTES_LIMIT => (subTimes / SECONDS_LIMIT).round().toString() +
          ((curLocale != null)
              ? (curLocale!.languageCode != "zh")
                  ? " min ago"
                  : " 分钟前"
              : " 分钟前"),
      < HOURS_LIMIT => (subTimes / MINUTES_LIMIT).round().toString() +
          ((curLocale != null)
              ? (curLocale!.languageCode != "zh")
                  ? " hours ago"
                  : " 小时前"
              : " 小时前"),
      < DAYS_LIMIT => (subTimes / HOURS_LIMIT).round().toString() +
          ((curLocale != null)
              ? (curLocale!.languageCode != "zh")
                  ? " days ago"
                  : " 天前"
              : " 天前"),
      _ => getDateStr(date)
    };
  }

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

  static Future<String> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      return '';
    }
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.model;
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

  static void launchWebView(BuildContext context, String? title, String url) {
    if (url.startsWith('http')) {
      NavigatorUtils.gotoGSYWebView(context, url, title);
    } else {
      NavigatorUtils.gotoGSYWebView(
        context,
        Uri.dataFromString(url, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString(),
        title,
      );
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

  static Future<Null> showLoadingDialog(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return NavigatorUtils.showGSYDialog(
      context: context,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: PopScope(
            canPop: false,
            child: Center(
              child: Container(
                width: 200,
                height: 200,
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SpinKitCubeGrid(
                      color: GSYColors.white,
                    ),
                    Container(
                      height: 10,
                    ),
                    Text(
                      localization.loading_text,
                      style: GSYConstant.normalTextWhite,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<Null> showCommitOptionDialog(
    BuildContext context,
    List<String?>? commitMaps,
    ValueChanged<int> onTap, {
    width = 250,
    height = 400,
    List<Color>? colorList,
  }) {
    return NavigatorUtils.showGSYDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            width: width,
            height: height,
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: GSYColors.white,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return GSYFlexButton(
                  maxLines: 1,
                  mainAxisAlignment: MainAxisAlignment.start,
                  fontSize: 14,
                  color: colorList != null ? colorList[index] : Theme.of(context).primaryColor,
                  text: commitMaps![index],
                  textColor: GSYColors.white,
                  onPress: () {
                    Navigator.pop(context);
                    onTap(index);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  static Future<Null> showUpdateDialog(BuildContext context, String contentMsg) {
    final localization = AppLocalizations.of(context)!;
    return NavigatorUtils.showGSYDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(localization.app_version_title),
          content: Text(contentMsg),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(localization.app_cancel),
            ),
            TextButton(
              onPressed: () {
                launchUrl(Uri.parse(Address.updateUrl));
                Navigator.pop(context);
              },
              child: Text(localization.app_ok),
            ),
          ],
        );
      },
    );
  }
}
