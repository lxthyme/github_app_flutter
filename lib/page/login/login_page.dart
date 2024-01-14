import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gsy_app/common/dao/user_dao.dart';
import 'package:gsy_app/common/net/address.dart';
import 'package:gsy_app/common/utils/navigator_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gsy_app/redux/gsy_state.dart';

class LoginPage extends StatelessWidget {
  static String sName = 'login';
  const LoginPage({super.key});

  oauthLogin(BuildContext context) async {
    final localization = AppLocalizations.of(context)!;
    String? code = await NavigatorUtils.gotoLoginWebView(context, Address.getOAuthUrl(), localization.oauth_text);
    debugPrint('-->code[1]: $code');
    if (code != null && code.isNotEmpty) {
      // StoreProvider.of<GSYState>(context).dispatch(O)
    }
    var res = await UserDao.oauth(code, null);
    debugPrint('-->login res: $res');
  }

  void goMain() {}
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                CupertinoButton(
                  onPressed: () {
                    oauthLogin(context);
                  },
                  child: const Text('安全登录'),
                ),
                CupertinoButton(
                  onPressed: goMain,
                  child: const Text('去首页'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
