import 'package:gsy_app/page/assets-test.dart';
import 'package:gsy_app/page/home/home_page.dart';
import 'package:gsy_app/page/login/login_page.dart';
import 'package:gsy_app/page/welcome_page.dart';

class RouterName {
  static String welcome = '/';
  static String home = 'home';
  static String assetTest = 'assetTest';
  static String login = 'login';

  Function getPageWidget(String router) {
    switch (router) {
      case '/': return () => const WelcomePage();
      case 'home': return () => const HomePage();
      case 'assetTest': return () => AssetsTest();
      case 'login': return () => const LoginPage();
    }
    return () => const WelcomePage();
  }
}
