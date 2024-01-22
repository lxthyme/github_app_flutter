import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gsy_app/common/dao/repos_dao.dart';
import 'package:gsy_app/common/dao/user_dao.dart';
import 'package:gsy_app/common/utils/event_utils.dart';
import 'package:gsy_app/common/utils/navigator_utils.dart';
import 'package:gsy_app/model/Event.dart';
import 'package:gsy_app/model/User.dart';
import 'package:gsy_app/model/UserOrg.dart';
import 'package:gsy_app/page/user/widget/user_header.dart';
import 'package:gsy_app/page/user/widget/user_item.dart';
import 'package:gsy_app/widget/gsy_event_item.dart';
import 'package:gsy_app/widget/pull/nested/gsy_sliver_header_delegate.dart';
import 'package:gsy_app/widget/pull/nested/nested_refresh.dart';
import 'package:gsy_app/widget/state/gsy_list_state.dart';
import 'package:provider/provider.dart';

abstract class BasePersonState<T extends StatefulWidget> extends State<T>
    with AutomaticKeepAliveClientMixin<T>, GSYListState<T>, SingleTickerProviderStateMixin {
  final GlobalKey<NestedScrollViewRefreshIndicatorState> refreshKey =
      GlobalKey<NestedScrollViewRefreshIndicatorState>();
  final List<UserOrg> orgList = [];
  final HonorModel honorModel = HonorModel();
  // const BasePersonState({super.key});

  @override
  showRefreshLoading() {
    Future.delayed(const Duration(seconds: 0), () {
      refreshKey.currentState?.show().then((value) {});
      return true;
    });
  }

  @protected
  renderItem(
    index,
    User userInfo,
    String beStaredCount,
    Color? notifyColor,
    VoidCallback? refreshCallBack,
    List<UserOrg> orgList,
  ) {
    if (userInfo.type == 'Organization') {
      var userItemVM = UserItemVM.fromMap(pullLoadWidgetControl.dataList[index]);
      return UserItem(
        userItemVM,
        onPressed: () {
          NavigatorUtils.goPerson(context, userItemVM.userName);
        },
      );
    } else {
      Event event = pullLoadWidgetControl.dataList[index];
      return GSYEventItem(
        EventVM.fromEventMap(event),
        onPressed: () {
          EventUtils.ActionUtils(context, event, '');
        },
      );
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  bool get isRefreshFirst => true;

  @override
  bool get needHeader => true;

  @protected
  getUserOrg(String? userName) {
    if (page <= 1 && userName != null) {
      UserDao.getUserOrgsDao(userName, page, needDb: true).then((res) {
        if (res != null && res.result) {
          setState(() {
            orgList.clear();
            orgList.addAll(res.data);
          });
          return res.next?.call();
        }
        return Future.value(null);
      }).then((res) {
        if (res != null && res.result) {
          setState(() {
            orgList.clear();
            orgList.addAll(res.data);
          });
        }
      });
    }
  }

  @protected
  List<Widget> sliverBuilder(BuildContext context, bool innerBoxIsScrolled, User userInfo, Color? notifyColor,
      String beStaredCount, refreshCallBack) {
    double headerSize = 260;
    double bottomSize = 70;
    double chartSize = (userInfo.login != null && userInfo.type == 'Organization') ? 70 : 215;
    return <Widget>[
      SliverPersistentHeader(
        pinned: true,
        delegate: GSYSliverHeaderDelegate(
            minHeight: headerSize,
            maxHeight: headerSize,
            snapConfig: FloatingHeaderSnapConfiguration(
              curve: Curves.bounceInOut,
              duration: const Duration(milliseconds: 10),
            ),
            vSyncs: this,
            changeSize: true,
            builder: (context, shrinkOffset, overlapsContent) {
              return Transform.translate(
                offset: Offset(0, -shrinkOffset),
                child: SizedBox.expand(
                  child: UserHeaderItem(
                    userInfo,
                    beStaredCount,
                    Theme.of(context).primaryColor,
                    notifyColor: notifyColor,
                    refreshCallBack: refreshCallBack,
                    orgList: orgList,
                  ),
                ),
              );
            }),
      ),
      SliverPersistentHeader(
        pinned: true,
        floating: true,
        delegate: GSYSliverHeaderDelegate(
            minHeight: bottomSize,
            maxHeight: bottomSize,
            snapConfig: FloatingHeaderSnapConfiguration(
              curve: Curves.bounceInOut,
              duration: const Duration(milliseconds: 10),
            ),
            vSyncs: this,
            changeSize: true,
            builder: (context, shrinkOffset, overlapsContent) {
              var radius = Radius.circular(10 - shrinkOffset / bottomSize * 10);
              return SizedBox.expand(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: MultiProvider(
                    providers: [
                      ChangeNotifierProvider(create: (context) => honorModel),
                    ],
                    child: Consumer<HonorModel>(
                      builder: (context, value, child) {
                        return UserHeaderBottom(
                            userInfo, value.beStaredCount?.toString() ?? '---', radius, value.honorList);
                      },
                    ),
                  ),
                ),
              );
            }),
      ),
      SliverPersistentHeader(
        delegate: GSYSliverHeaderDelegate(
            minHeight: chartSize,
            maxHeight: chartSize,
            snapConfig: FloatingHeaderSnapConfiguration(
              curve: Curves.bounceInOut,
              duration: const Duration(milliseconds: 10),
            ),
            vSyncs: this,
            changeSize: true,
            builder: (context, shrinkOffset, overlapsContent) {
              return SizedBox.expand(
                child: Container(
                  height: chartSize,
                  child: UserHeaderChart(userInfo),
                ),
              );
            }),
      ),
    ];
  }

  getHonor(name) {
    ReposDao.getUserRepository100StatusDao(name).then((res) {
      if (res != null && res.result) {
        if (isShow) {
          honorModel.beStaredCount = res.data['stared'];
          honorModel.honorList = res.data['list'];
        }
      }
    });
  }
}

class HonorModel extends ChangeNotifier {
  int? _beStaredCount;
  int? get beStaredCount => _beStaredCount;
  set beStaredCount(int? value) {
    _beStaredCount = value;
    notifyListeners();
  }

  List? _honorList;
  List? get honorList => _honorList;
  set honorList(List? value) {
    _honorList = value;
    notifyListeners();
  }
}
