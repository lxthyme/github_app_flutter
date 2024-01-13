import 'package:flutter/material.dart';
import 'package:gsy_app/model/User.dart';
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
    userInfo: UserReducer(state.userInfo, action),
    // themeData: ThemeDataR
    // locale: LocalRe
    // login:
    // grey:
  );
}

final List<Middleware<GSYState>> middleware = [
  // Epic
];
