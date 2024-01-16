import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gsy_app/common/dao/repos_dao.dart';
import 'package:gsy_app/common/dao/user_dao.dart';
import 'package:gsy_app/common/utils/event_utils.dart';
import 'package:gsy_app/model/Event.dart';
import 'package:gsy_app/page/dynamic/dynamic_bloc.dart';
import 'package:gsy_app/redux/gsy_state.dart';
import 'package:gsy_app/widget/gsy_event_item.dart';
import 'package:gsy_app/widget/pull/gsy_pull_new_load_widget.dart';
import 'package:redux/redux.dart';

class DynamicPage extends StatefulWidget {
  const DynamicPage({super.key});

  @override
  State<DynamicPage> createState() => _DynamicPageState();
}

class _DynamicPageState extends State<DynamicPage>
    with AutomaticKeepAliveClientMixin<DynamicPage>, WidgetsBindingObserver {
  final DynamicBloc dynamicBloc = DynamicBloc();

  final ScrollController scrollController = ScrollController();

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  bool _ignoring = true;

  showRefreshLoading() {
    Future.delayed(const Duration(milliseconds: 500), () {
      scrollController
          .animateTo(-141, duration: const Duration(milliseconds: 600), curve: Curves.linear)
          .then((value) {});
      return true;
    });
  }

  scrollToTop() {
    if (scrollController.offset <= 0) {
      scrollController.animateTo(0, duration: const Duration(milliseconds: 600), curve: Curves.linear).then((value) {
        showRefreshLoading();
      });
    } else {
      scrollController.animateTo(0, duration: const Duration(milliseconds: 600), curve: Curves.linear);
    }
  }

  Future<void> requestRefresh() async {
    var username = _getStore().state.userInfo?.login;
    if (username == null || username.isEmpty) {
      debugPrint('-->[backup]get userinfo from local');
      await UserDao.initUserInfo(_getStore());
    }
    debugPrint('-->_getStore(): ${_getStore()}');
    debugPrint('-->_getStore().state: ${_getStore().state}');
    debugPrint('-->_getStore().state.userInfo: ${_getStore().state.userInfo?.toJson()}');
    debugPrint('-->_getStore().state.userInfo?.login: ${_getStore().state.userInfo?.login}');
    await dynamicBloc.requestRefresh(_getStore().state.userInfo?.login).catchError((e) {
      debugPrint('-->[dynamic_page]error: $e');
    });
    setState(() {
      _ignoring = false;
    });
  }

  Future<void> requestLoadMore() async {
    return await dynamicBloc.requestLoadMore(_getStore().state.userInfo?.login);
  }

  _renderEventItem(Event e) {
    EventVM eventVM = EventVM.fromEventMap(e);
    return GSYEventItem(
      eventVM,
      onPressed: () {
        EventUtils.ActionUtils(context, e, '');
      },
    );
  }

  Store<GSYState> _getStore() {
    return StoreProvider.of(context);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    ReposDao.getNewsVersion(context, false);

    if (dynamicBloc.getDataLength() == 0) {
      dynamicBloc.changeNeedHeaderStatus(false);

      dynamicBloc.requestRefresh(_getStore().state.userInfo?.login, doNextFlag: false).then((_) {
        showRefreshLoading();
      });
    }
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (dynamicBloc.getDataLength() != 0) {
        showRefreshLoading();
      }
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    dynamicBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    debugPrint('-->dynamicBloc.dataList: ${dynamicBloc.dataList}');
    var content = GSYPullLoadWidget(
      dynamicBloc.pullLoadWidgetControl,
      (context, index) => _renderEventItem(dynamicBloc.dataList[index]),
      requestRefresh,
      requestLoadMore,
      refreshKey: refreshIndicatorKey,
      scrollController: scrollController,
      userIos: true,
    );
    return IgnorePointer(
      ignoring: _ignoring,
      child: content,
    );
  }
}
