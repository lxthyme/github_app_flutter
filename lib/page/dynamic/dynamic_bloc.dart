import 'package:gsy_app/common/config/config.dart';
import 'package:gsy_app/common/dao/event_dao.dart';
import 'package:gsy_app/widget/pull/gsy_pull_new_load_widget.dart';

class DynamicBloc {
  final GSYPullLoadWidgetControl pullLoadWidgetControl = GSYPullLoadWidgetControl();

  int _page = 1;

  requestRefresh(String? userName, {doNextFlag = true}) async {
    pageReset();
    var res = await EventDao.getEventReceived(userName, page: _page, needDb: true);
    changeLoadMoreStatus(getLoadMoreStatus(res));
    refreshData(res);
    if (doNextFlag) {
      await doNext(res);
    }
    return res;
  }

  requestLoadMore(String? userName) async {
    pageUp();
    var res = await EventDao.getEventReceived(userName, page: _page);
    changeLoadMoreStatus(getLoadMoreStatus(res));
    loadMoreData(res);
    return res;
  }

  pageReset() {
    _page = 1;
  }

  pageUp() {
    _page++;
  }

  getLoadMoreStatus(res) {
    return res != null && res.data != null && res.data.length == Config.PAGE_SIZE;
  }

  doNext(res) async {
    if (res?.next != null) {
      var resNext = await res.next();
      if (resNext != null && resNext.result) {
        changeLoadMoreStatus(getLoadMoreStatus(resNext));
        refreshData(resNext);
      }
    }
  }

  int? getDataLength() {
    return pullLoadWidgetControl.dataList?.length;
  }

  changeLoadMoreStatus(bool needLoadMore) {
    pullLoadWidgetControl.needLoadMore = needLoadMore;
  }

  changeNeedHeaderStatus(bool needHeader) {
    pullLoadWidgetControl.needHeader = needHeader;
  }

  refreshData(res) {
    if (res != null) {
      pullLoadWidgetControl.dataList = res.data;
    }
  }

  loadMoreData(res) {
    if (res != null) {
      pullLoadWidgetControl.addList(res.data);
    }
  }

  clearData() {
    refreshData([]);
  }

  get dataList => pullLoadWidgetControl.dataList;
  void dispose() {
    pullLoadWidgetControl.dispose();
  }
}
