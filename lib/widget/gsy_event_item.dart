import 'package:flutter/material.dart';
import 'package:gsy_app/common/style/gsy_style.dart';
import 'package:gsy_app/common/utils/common_utils.dart';
import 'package:gsy_app/common/utils/event_utils.dart';
import 'package:gsy_app/common/utils/navigator_utils.dart';
import 'package:gsy_app/model/Event.dart';
import 'package:gsy_app/model/Notification.dart' as Model;
import 'package:gsy_app/model/RepoCommit.dart';
import 'package:gsy_app/l10n/gen_l10n/app_localizations.dart';
import 'package:gsy_app/widget/gsy_card_item.dart';
import 'package:gsy_app/widget/gsy_user_icon_widget.dart';

class GSYEventItem extends StatelessWidget {
  final EventVM eventVM;
  final VoidCallback? onPressed;
  final bool needImage;
  const GSYEventItem(this.eventVM, {this.onPressed, this.needImage = true});

  @override
  Widget build(BuildContext context) {
    Widget des = (eventVM.actionDes == null || eventVM.actionDes?.isEmpty == true)
        ? Container()
        : Container(
            margin: const EdgeInsets.only(top: 6, bottom: 2),
            alignment: Alignment.topLeft,
            child: Text(
              eventVM.actionDes ?? '--',
              style: GSYConstant.smallSubText,
              maxLines: 3,
            ),
          );
    Widget userImage = needImage
        ? GSYUserIconWidget(
            padding: const EdgeInsets.only(top: 0, right: 5, left: 0),
            width: 30,
            height: 30,
            image: eventVM.actionUserPic,
            onPressed: () {
              NavigatorUtils.goPerson(context, eventVM.actionUser);
            },
          )
        : Container();
    return Container(
      child: GSYCardItem(
          child: TextButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  userImage,
                  Expanded(
                    child: Text(
                      eventVM.actionUser!,
                      style: GSYConstant.normalTextBold,
                    ),
                  ),
                  Text(
                    eventVM.actionTime,
                    style: GSYConstant.smallSubText,
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 6, bottom: 2),
                alignment: Alignment.topLeft,
                child: Text(
                  eventVM.actionTarget!,
                  style: GSYConstant.smallTextBold,
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

class EventVM {
  String? actionUser;
  String? actionUserPic;
  String? actionDes;
  late String actionTime;
  String? actionTarget;

  EventVM.fromEventMap(Event event) {
    actionTime = CommonUtils.getNewsTimeStr(event.createdAt!);
    actionUser = event.actor?.login;
    actionUserPic = event.actor?.avatar_url;
    var as = EventUtils.getActionAndDes(event);
    actionDes = as.des;
    actionTarget = as.actionStr;
  }

  EventVM.fromCommitMap(RepoCommit eventMap) {
    actionTime = CommonUtils.getNewsTimeStr(eventMap.commit!.committer!.date!);
    actionUser = eventMap.commit?.committer?.name;
    actionDes = 'sha:${eventMap.sha!}';
    actionTarget = eventMap.commit?.message;
  }

  EventVM.fromNotify(BuildContext context, Model.Notification eventMap) {
    final localization = AppLocalizations.of(context)!;
    actionTime = CommonUtils.getNewsTimeStr(eventMap.updateAt!);
    actionUser = eventMap.repository?.fullName;
    String? type = eventMap.subject?.type;
    String status = eventMap.unread! ? localization.notify_unread : localization.notify_readed;
    actionDes = '${eventMap.reason}${localization.notify_type}: $type, ${localization.notify_status}: $status';
    actionTarget = eventMap.subject?.title;
  }
}
