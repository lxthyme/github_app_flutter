// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:gsy_app/common/dao/user_dao.dart';
import 'package:gsy_app/redux/gsy_state.dart';
import 'package:gsy_app/redux/middleware/epic_store.dart';
import 'package:redux/redux.dart';
import 'package:gsy_app/model/User.dart';
import 'package:rxdart/rxdart.dart';

final UserReducer = combineReducers<User?>([
  TypedReducer<User?, UpdateUserAction>(_updateLoaded),
]);

User? _updateLoaded(User? user, action) {
  user = action.userInfo;
  debugPrint('-->UserReducer -> _updateLoaded: ${user?.toJson()}');
  return user;
}

class UpdateUserAction {
  final User? userInfo;

  UpdateUserAction(this.userInfo);
}

class FetchUserAction {}

class UserInfoMiddleware implements MiddlewareClass<GSYState> {
  @override
  call(Store<GSYState> store, action, NextDispatcher next) {
    if (action is UpdateUserAction) {
      debugPrint("*********** UserInfoMiddleware *********** ");
    }
    next(action);
  }
}

Stream<dynamic> userInfoEpic(Stream<dynamic> actions, EpicStore<GSYState> store) {
  Stream<dynamic> _loadUserInfo() async* {
    debugPrint("*********** userInfoEpic _loadUserInfo ***********");
    var res = await UserDao.getUserInfo(null);
    yield UpdateUserAction(res.data);
  }

  return actions
      .whereType<FetchUserAction>()
      .debounce((event) => TimerStream(true, const Duration(milliseconds: 10)))
      .switchMap((value) => _loadUserInfo());
}
