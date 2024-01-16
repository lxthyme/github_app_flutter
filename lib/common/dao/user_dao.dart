import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gsy_app/common/config/config.dart';
import 'package:gsy_app/common/dao/dao_result.dart';
import 'package:gsy_app/common/local/local_storage.dart';
import 'package:gsy_app/common/net/address.dart';
import 'package:gsy_app/common/net/api.dart';
import 'package:gsy_app/common/utils/common_utils.dart';
import 'package:gsy_app/db/provider/user/userinfo_db_provider.dart';
import 'package:gsy_app/model/User.dart';
import 'package:gsy_app/redux/gsy_state.dart';
import 'package:gsy_app/redux/locale_redux.dart';
import 'package:gsy_app/redux/user_redux.dart';
import 'package:redux/redux.dart';

class UserDao {
  static oauth(code, store) async {
    httpManager.clearAuthorization();

    var res = await httpManager.netFetch(
      'https://github.com/login/oauth/access_token?client_id=${NetConfig.CLIENT_ID}&client_secret=${NetConfig.CLIENT_SECRET}&code=$code',
      null,
      null,
      Options(method: 'POST'),
    );
    dynamic resultData;
    debugPrint('--> login res: $res');
    if (res != null && res.result) {
      var result = Uri.parse('gsy://oauth?${res.data}');
      var token = result.queryParameters['access_token'];
      debugPrint('--> login token: $token');
      var _token = 'token $token';
      await LocalStorage.save(Config.TOKEN_KEY, _token);

      resultData = await getUserInfo(null);
      // if (Config.DEBUG!) {
      debugPrint('-->user result: ${resultData.result.toString()}');
      debugPrint('-->resultData.data: ${resultData.data}');
      debugPrint('-->res.data: ${res.data.toString()}');
      // }
      if (resultData.result == true) {
        // store.dispatch(UpdateUserAction(resultData.data));
      }
    }

    return DataResult(resultData, res!.result);
  }

  static login(userName, password, store) async {
    debugPrint('-->login todo...');
  }

  static initUserInfo(Store<GSYState> store) async {
    var token = await LocalStorage.get(Config.TOKEN_KEY);
    var res = await getUserInfoLocal();
    if (res != null && res.result && token != null) {
      store.dispatch(UpdateUserAction(res.data));
    }

    String? themeIndex = await LocalStorage.get(Config.THEME_COLOR);
    if (themeIndex != null && themeIndex.isNotEmpty) {
      CommonUtils.pushTheme(store, int.parse(themeIndex));
    }

    String? localeIndex = await LocalStorage.get(Config.LOCALE);
    if (localeIndex != null && localeIndex.isNotEmpty) {
      CommonUtils.changeLocale(store, int.parse(localeIndex));
    } else {
      CommonUtils.curLocale = store.state.platformLocale;
      store.dispatch(RefreshLocaleAction(store.state.platformLocale));
    }

    return DataResult(res.data, (res.result && (token != null)));
  }

  static getUserInfoLocal() async {
    var userText = await LocalStorage.get(Config.USER_INFO);
    if (userText != null) {
      var userMap = json.decode(userText);
      User user = User.fromJson(userMap);
      debugPrint('-->getUserInfoLocal: ${user.toJson()}');
      return DataResult(user, true);
    } else {
      return DataResult(null, false);
    }
  }

  static getUserInfo(userName, {needDb = false}) async {
    UserInfoDbProvider provider = UserInfoDbProvider();
    next() async {
      debugPrint('-->getUserInfo begin: $userName');
      var res;
      if (userName == null) {
        res = await httpManager.netFetch(Address.getMyUserInfo(), null, null, null);
      } else {
        res = await httpManager.netFetch(Address.getUserInfo(userName), null, null, null);
      }
      debugPrint('-->getUserInfo: $res');
      if (res != null && res.result) {
        String starred = '---';
        if (res.data['type'] != 'Organization') {
          var countRes = await getUserStarredCountNet(res.data['login']);
          if (countRes.result) {
            starred = countRes.data;
          }
        }
        User user = User.fromJson(res.data);
        user.starred = starred;
        if (userName == null) {
          LocalStorage.save(Config.USER_INFO, json.encode(user.toJson()));
        } else {
          if (needDb) {
            provider.insert(userName, json.encode(user.toJson()));
          }
        }
        debugPrint('-->getUserInfo: ${user.toJson()}');
        return DataResult(user, true);
      } else {
        return DataResult(res.data, false);
      }
    }

    if (needDb) {
      User? user = await provider.getUserInfo(userName);
      if (user == null) {
        return await next();
      }
      DataResult dataResult = DataResult(user, true, next: next);
      debugPrint('-->getUserInfo: $user');
      return dataResult;
    }
    return await next();
  }

  static clearAll(Store store) async {
    httpManager.clearAuthorization();
    LocalStorage.remove(Config.USER_INFO);
    store.dispatch(UpdateUserAction(User.empty()));
  }

  static getUserStarredCountNet(userName) async {
    String url = Address.userStar(userName, null) + '&per_page=1';
    var res = await httpManager.netFetch(url, null, null, null);
    if (res != null && res.result && res.headers != null) {
      try {
        StringList? link = res.headers['link'];
        if (link != null) {
          var [linkFirst] = link;
          int indexStart = linkFirst.lastIndexOf('page=') + 5;
          int indexEnd = linkFirst.lastIndexOf('>');
          if (indexStart >= 0 && indexEnd >= 0) {
            String count = linkFirst.substring(indexStart, indexEnd);
            return DataResult(count, true);
          }
        }
      } catch (e) {
        debugPrint('-->E[getUserStarredCountNet]: $e');
      }
    }
    return DataResult(null, false);
  }
}
