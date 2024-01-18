import 'package:flutter/material.dart';
import 'package:gsy_app/common/style/gsy_style.dart';
import 'package:gsy_app/common/utils/navigator_utils.dart';
import 'package:gsy_app/l10n/gen_l10n/app_localizations.dart';
import 'package:gsy_app/model/CommonListDataType.dart';
import 'package:gsy_app/model/User.dart';
import 'package:gsy_app/model/UserOrg.dart';
import 'package:gsy_app/widget/gsy_icon_test.dart';
import 'package:gsy_app/widget/gsy_user_icon_widget.dart';

class UserHeaderItem extends StatelessWidget {
  final User userInfo;
  final String beStaredCount;
  final Color? notifyColor;
  final Color themeColor;
  final VoidCallback? refreshCallBack;
  final List<UserOrg>? orgList;
  const UserHeaderItem(
    this.userInfo,
    this.beStaredCount,
    this.themeColor, {
    super.key,
    this.notifyColor,
    this.refreshCallBack,
    this.orgList,
  });

  _getNotifyIcon(BuildContext context, Color? color) {
    if (notifyColor == null) {
      return Container();
    }
    return RawMaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.only(
        left: 5,
        right: 5,
      ),
      constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      child: ClipOval(
        child: Icon(
          GSYICons.USER_NOTIFY,
          color: color,
          size: 18,
        ),
      ),
      onPressed: () {
        NavigatorUtils.goNotifyPage(context).then((value) => refreshCallBack?.call());
      },
    );
  }

  _renderOrgs(BuildContext context, List<UserOrg>? orgList) {
    if (orgList == null || orgList.isEmpty) {
      return Container();
    }
    renderOrgsItem(UserOrg orgs) {
      return GSYUserIconWidget(
        padding: const EdgeInsets.only(left: 5, right: 5),
        width: 30,
        height: 30,
        image: orgs.avatarUrl ?? GSYICons.DEFAULT_REMOTE_PIC,
        onPressed: () {
          NavigatorUtils.goPerson(context, orgs.login);
        },
      );
    }

    final localization = AppLocalizations.of(context)!;

    int length = orgList.length > 3 ? 3 : orgList.length;
    List<Widget> list = [];
    list.add(Text(
      '${localization.user_orgs_title}:',
      style: GSYConstant.smallSubLightText,
    ));

    for (int i = 0; i < length; i++) {
      list.add(renderOrgsItem(orgList[i]));
    }
    if (orgList.length > 3) {
      list.add(RawMaterialButton(
        onPressed: () {
          NavigatorUtils.gotoCommonList(
            context,
            '${userInfo.login} ${localization.user_orgs_title}',
            'org',
            CommonListDataType.userOrgs,
            userName: userInfo.login,
          );
        },
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.only(left: 5, top: 5),
        constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        child: const Icon(
          Icons.more_horiz,
          color: GSYColors.white,
          size: 18,
        ),
      ));
    }
    return Row(children: list);
  }

  _renderImg(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        if (userInfo.avatar_url != null) {
          NavigatorUtils.gotoPhotoViewPage(context, userInfo.avatar_url);
        }
      },
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.all(0),
      constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      child: ClipOval(
        child: FadeInImage.assetNetwork(
          placeholder: GSYICons.DEFAULT_USER_ICON,
          image: userInfo.avatar_url ?? GSYICons.DEFAULT_REMOTE_PIC,
          fit: BoxFit.fitWidth,
          width: 80,
          height: 80,
        ),
      ),
    );
  }

  _renderUserInfo(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              userInfo.login ?? '',
              style: GSYConstant.largeTextWhiteBold,
            ),
            _getNotifyIcon(context, notifyColor),
          ],
        ),
        Text(
          userInfo.name ?? '',
          style: GSYConstant.smallSubLightText,
        ),
        GSYIconText(
          GSYICons.USER_ITEM_COMPANY,
          userInfo.company ?? localization.nothing_now,
          GSYConstant.smallSubLightText,
          GSYColors.subLightTextColor,
          10,
          padding: 3,
        ),
        GSYIconText(
          GSYICons.USER_ITEM_LOCATION,
          userInfo.location ?? localization.nothing_now,
          GSYConstant.smallSubLightText,
          GSYColors.subLightTextColor,
          10,
          padding: 0,
        ),
      ],
    );
  }

  _renderBloc(BuildContext context) {
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
