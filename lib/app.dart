import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gsy_app/common/event/http_error_event.dart';
import 'package:gsy_app/common/event/index.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gsy_app/common/net/code.dart';
import 'package:gsy_app/common/style/gsy_style.dart';
import 'package:gsy_app/common/utils/common_utils.dart';
import 'package:gsy_app/common/utils/navigator_utils.dart';
import 'package:gsy_app/model/User.dart';
import 'package:gsy_app/page/assets-test.dart';
import 'package:gsy_app/page/debug/debug_label.dart';
import 'package:gsy_app/page/dynamic/dynamic_page.dart';
import 'package:gsy_app/page/error_page.dart';
import 'package:gsy_app/page/home/home_page.dart';
import 'package:gsy_app/page/login/login_page.dart';
import 'package:gsy_app/page/welcome_page.dart';
import 'package:gsy_app/redux/gsy_state.dart';
import 'package:gsy_app/router.dart';
import 'package:redux/redux.dart';

class FlutterReduxApp extends StatefulWidget {
  final String initialRoute;
  const FlutterReduxApp({super.key, this.initialRoute = '/'});

  @override
  State<FlutterReduxApp> createState() => _FlutterReduxAppState();
}

class _FlutterReduxAppState extends State<FlutterReduxApp> with HttpErrorListener {
  final store = Store<GSYState>(
    appReducer,
    middleware: middleware,
    initialState: GSYState(
      userInfo: User.empty(),
      login: false,
      themeData: CommonUtils.getThemeData(GSYColors.primarySwatch),
      locale: const Locale('zh', 'CN'),
    ),
  );

  ColorFilter greyscale = const ColorFilter.matrix(<double>[
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]);

  NavigatorObserver navigatorObserver = NavigatorObserver();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 0), () {
      navigatorObserver.navigator?.context;
      navigatorObserver.navigator;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: StoreBuilder<GSYState>(builder: (context, vm) {
        store.state.platformLocale = WidgetsBinding.instance.platformDispatcher.locale;
        Widget app = MaterialApp(
          navigatorKey: navKey,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            AppLocalizations.delegate,
          ],
          supportedLocales: [store.state.locale ?? store.state.platformLocale!],
          locale: store.state.locale,
          theme: store.state.themeData,
          navigatorObservers: [navigatorObserver],
          initialRoute: widget.initialRoute,
          routes: {
            RouterName.assetTest: (context) {
              DebugLabel.showDebugLabel(context);
              debugPrint('-->router: AssetsTest');
              return const AssetsTest();
            },
            RouterName.welcome: (context) {
              DebugLabel.showDebugLabel(context);
              debugPrint('-->router: WelcomePage');
              return const WelcomePage();
            },
            RouterName.home: (context) {
              // return NavigatorUtils.pageContainer(const HomePage(), context);
              debugPrint('-->router: HomePage');
              return NavigatorUtils.pageContainer(const DynamicPage(), context);
            },
            RouterName.login: (context) {
              debugPrint('-->router: LoginPage');
              return NavigatorUtils.pageContainer(const LoginPage(), context);
            },
          },
          onUnknownRoute: (settings) {
            debugPrint('-->onUnknownRoute: ${settings.name}\t${settings.arguments}\n${settings.toString()}');
            return null;
          },
          onGenerateRoute: (settings) {
            debugPrint('-->onGenerateRoute: ${settings.name}\t${settings.arguments}\n${settings.toString()}');
            return null;
          },
        );

        if (store.state.grey) {
          app = ColorFiltered(
            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.saturation),
            child: app,
          );
        }

        return app;
      }),
    );
  }
}

mixin HttpErrorListener on State<FlutterReduxApp> {
  StreamSubscription? stream;
  GlobalKey<NavigatorState> navKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    stream = eventBus.on<HttpErrorEvent>().listen((event) {
      errorHandleFunction(event.code, event.message);
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (stream != null) {
      stream?.cancel();
      stream = null;
    }
  }

  errorHandleFunction(int? code, message) {
    var context = navKey.currentContext;
    final localization = AppLocalizations.of(context!)!;
    switch (code) {
      case Code.NETWORK_ERROR:
        showToast(localization.network_error);
        break;
      case 401:
        showToast(localization.network_error_401);
        break;
      case 403:
        showToast(localization.network_error_403);
        break;
      case 404:
        showToast(localization.network_error_404);
        break;
      case 422:
        showToast(localization.network_error_422);
        break;
      case Code.NETWORK_TIMEOUT:
        showToast(localization.network_error_timeout);
        break;
      case Code.GITHUB_API_REFUSED:
        showToast(localization.github_refused);
        break;
      default:
        showToast('${localization.network_error_unknown}$message');
        break;
    }
  }

  showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.CENTER,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}
