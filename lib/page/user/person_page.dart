import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gsy_app/common/dao/event_dao.dart';
import 'package:gsy_app/common/dao/user_dao.dart';
import 'package:gsy_app/common/utils/common_utils.dart';
import 'package:gsy_app/l10n/gen_l10n/app_localizations.dart';
import 'package:gsy_app/model/User.dart';
import 'package:gsy_app/model/UserOrg.dart';
import 'package:gsy_app/page/user/base_persion_state.dart';
import 'package:gsy_app/widget/gsy_common_option_widget.dart';
import 'package:gsy_app/widget/gsy_title_bar.dart';
import 'package:gsy_app/widget/pull/nested/gsy_nested_pull_load_widget.dart';

class PersonPage extends StatefulWidget {
  final String? userName;
  const PersonPage(this.userName, {super.key});

  @override
  State<PersonPage> createState() => _PersonPageState(userName);
}

class _PersonPageState extends BasePersonState<PersonPage> {
  final String? userName;
  String beStaredCount = '---';
  bool focusStatus = false;
  String focus = '';
  User? userInfo = User.empty();
  final List<UserOrg> orgList = [];
  _PersonPageState(this.userName);

  _resolveUserInfo(res) {
    if (isShow) {
      setState(() {
        userInfo = res.data;
      });
    }
  }

  @override
  Future<Null> handleRefresh() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page = 1;

    var userResult = await UserDao.getUserInfo(userName, needDb: true);
    if (userResult != null && userResult.result) {
      _resolveUserInfo(userResult);
      if (userResult.next != null) {
        userResult.next().then((resNext) {
          _resolveUserInfo(resNext);
        });
      }
    } else {
      return null;
    }

    var res = await _getDataLogic();
    resolveRefreshResult(res);
    resolveDataResult(res);
    if (res.next != null) {
      var resNext = await res.next();
      resolveRefreshResult(resNext);
      resolveDataResult(resNext);
    }
    isLoading = false;

    _getFocusStatus();

    getHonor(_getUserName());
    return null;
  }

  _getFocusStatus() async {
    final localization = AppLocalizations.of(context)!;
    var focusRes = await UserDao.checkFollowDao(userName);
    if (isShow) {
      setState(() {
        focus = (focusRes != null && focusRes.result) ? localization.user_focus : localization.user_un_focus;
        focusStatus = focusRes != null && focusRes.result;
      });
    }
  }

  _getUserName() {
    if (userInfo == null) {
      return User.empty();
    }
    return userInfo!.login;
  }

  _getDataLogic() async {
    debugPrint('-->userInfo?.type: ${userInfo?.type}');
    if (userInfo?.type == 'Organization') {
      return await UserDao.getMemberDao(_getUserName(), page);
    }
    getUserOrg(_getUserName());
    return await EventDao.getEventDao(_getUserName(), page: page, needDb: page <= 1);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  requestRefresh() async {}

  @override
  requestLoadMore() async {
    return await _getDataLogic();
  }

  @override
  bool get isRefreshFirst => true;

  @override
  bool get needHeader => false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: GSYTitleBar(
          userInfo?.login ?? '',
          rightWidget: GSYCommonOptionWidget(
            url: userInfo?.html_url,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        if (focus == '') {
          return;
        }
        if (userInfo?.type == 'Organization') {
          Fluttertoast.showToast(msg: localization.user_focus_no_support);
          return;
        }
        CommonUtils.showLoadingDialog(context);
        UserDao.doFollowDao(userName, focusStatus).then((res) {
          Navigator.pop(context);
          _getFocusStatus();
        });
      }),
      body: GSYNestedPullLoadWidget(
        pullLoadWidgetControl,
        (context, index) => renderItem(index, userInfo!, beStaredCount, null, null, orgList),
        handleRefresh,
        onLoadMore,
        refreshKey: refreshKey,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return sliverBuilder(context, innerBoxIsScrolled, userInfo!, null, beStaredCount, null);
        },
      ),
    );
  }
}
