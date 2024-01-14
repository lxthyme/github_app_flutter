import 'package:flutter/material.dart';
import 'package:gsy_app/model/User.dart';
import 'package:gsy_app/redux/login_redux.dart';
import 'package:gsy_app/redux/middleware/epic_middleware.dart';
import 'package:gsy_app/redux/theme_redux.dart';
import 'package:gsy_app/redux/user_redux.dart';
import 'package:redux/redux.dart';

class GSYState {
  User? userInfo;
  ThemeData? themeData;
  Locale? locale;
  Locale? platformLocale;
  bool? login;
  bool grey;

  GSYState({
    this.userInfo,
    this.themeData,
    this.locale,
    this.login,
    this.grey = false,
  });
}

GSYState appReducer(GSYState state, action) {
  return GSYState(
    userInfo: UserReducer(state.userInfo, action), themeData: ThemeDataReducer(state.themeData, action),
    // locale: LocalRed
    // login: Login
    // grey:
  );
}

final List<Middleware<GSYState>> middleware = [
  EpicMiddleware<GSYState>(loginEpic),
];
