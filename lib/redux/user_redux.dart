// ignore_for_file: non_constant_identifier_names

import 'package:redux/redux.dart';
import 'package:gsy_app/model/User.dart';

final UserReducer = combineReducers<User?>([
  TypedReducer<User?, UpdateUserAction>(_updateLoaded),
]);

User? _updateLoaded(User? user, action) {
  user = action.userInfo;
  return user;
}

class UpdateUserAction {
  final User? userInfo;

  UpdateUserAction(this.userInfo);
}
