import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gsy_app/common/style/gsy_style.dart';
import 'package:gsy_app/common/utils/common_utils.dart';
import 'package:gsy_app/common/utils/navigator_utils.dart';
import 'package:gsy_app/l10n/gen_l10n/app_localizations.dart';
import 'package:gsy_app/model/CommonListDataType.dart';
import 'package:gsy_app/model/User.dart';
import 'package:gsy_app/model/UserOrg.dart';
import 'package:gsy_app/widget/gsy_card_item.dart';
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
        padding: const EdgeInsets.only(left: 5, right: 5),
        constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        child: const Icon(
          Icons.more_horiz,
          color: GSYColors.white,
          size: 18,
        ),
      ));
    }
    return Row(
      // mainAxisSize: MainAxisSize.max,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: list,
    );
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
          placeholder: '${GSYICons.PACKAGE_PREFIX}${GSYICons.DEFAULT_USER_ICON}',
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
          padding: 3,
        ),
      ],
    );
  }

  _renderBlog(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(top: 6, bottom: 2),
      alignment: Alignment.topLeft,
      child: RawMaterialButton(
        onPressed: () {
          if (userInfo.blog != null) {
            CommonUtils.launchOutURL(userInfo.blog, context);
          }
        },
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.all(0),
        constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        child: GSYIconText(
          GSYICons.USER_ITEM_LINK,
          userInfo.blog ?? localization.nothing_now,
          userInfo.blog == null ? GSYConstant.smallSubLightText : GSYConstant.smallActionLightText,
          GSYColors.subLightTextColor,
          10,
          padding: 3,
          textWidth: MediaQuery.sizeOf(context).width - 50,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return GSYCardItem(
      color: themeColor,
      elevation: 0,
      margin: const EdgeInsets.all(0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _renderImg(context),
                const Padding(padding: EdgeInsets.all(10)),
                Expanded(child: _renderUserInfo(context)),
              ],
            ),
            _renderBlog(context),
            _renderOrgs(context, orgList),
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                userInfo.bio ?? '',
                // '${userInfo.bio}_${userInfo.bio}_${userInfo.bio}',
                style: GSYConstant.smallSubLightText,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 6, bottom: 2),
              alignment: Alignment.topLeft,
              child: Text(
                '${localization.user_create_at} ${CommonUtils.getDateStr(userInfo.created_at)}',
                style: GSYConstant.smallSubLightText,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 5)),
          ],
        ),
      ),
    );
  }
}

class UserHeaderBottom extends StatelessWidget {
  final User userInfo;
  final String beStaredCount;
  final Radius radius;
  final List? honorList;
  const UserHeaderBottom(
    this.userInfo,
    this.beStaredCount,
    this.radius,
    this.honorList, {
    super.key,
  });

  _getBottomItem(String? title, var value, onPressed) {
    String data = value.toString();
    TextStyle valueStyle =
        (value != null && value.toString().length > 6) ? GSYConstant.minText : GSYConstant.smallSubLightText;
    TextStyle titleStyle =
        (title != null && title.toString().length > 6) ? GSYConstant.minText : GSYConstant.smallSubLightText;

    return Expanded(
        child: Center(
      child: RawMaterialButton(
        onPressed: onPressed,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.only(top: 5),
        constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(text: title, style: titleStyle),
              TextSpan(text: '\n', style: valueStyle),
              TextSpan(text: data, style: valueStyle),
            ],
          ),
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return GSYCardItem(
      color: Theme.of(context).primaryColor,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(bottomLeft: radius, bottomRight: radius),
      ),
      child: Container(
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _getBottomItem(localization.user_tab_repos, userInfo.public_repos, () {
              NavigatorUtils.gotoCommonList(
                context,
                userInfo.login,
                'repository',
                CommonListDataType.userRepos,
                userName: userInfo.login,
              );
            }),
            Container(
              width: 0.3,
              height: 40,
              alignment: Alignment.center,
              color: GSYColors.subLightTextColor,
            ),
            _getBottomItem(localization.user_tab_fans, userInfo.followers, () {
              NavigatorUtils.gotoCommonList(
                context,
                userInfo.login,
                'user',
                CommonListDataType.follower,
                userName: userInfo.login,
              );
            }),
            Container(
              width: 0.3,
              height: 40,
              alignment: Alignment.center,
              color: GSYColors.subLightTextColor,
            ),
            _getBottomItem(
              localization.user_tab_focus,
              userInfo.following,
              () {
                NavigatorUtils.gotoCommonList(
                  context,
                  userInfo.login,
                  'user',
                  CommonListDataType.followed,
                  userName: userInfo.login,
                );
              },
            ),
            Container(
              width: 0.3,
              height: 40,
              alignment: Alignment.center,
              color: GSYColors.subLightTextColor,
            ),
            _getBottomItem(
              localization.user_tab_star,
              userInfo.starred,
              () {
                NavigatorUtils.gotoCommonList(
                  context,
                  userInfo.login,
                  'repository',
                  CommonListDataType.userStar,
                  userName: userInfo.login,
                );
              },
            ),
            Container(
              width: 0.3,
              height: 40,
              alignment: Alignment.center,
              color: GSYColors.subLightTextColor,
            ),
            _getBottomItem(localization.user_tab_honor, beStaredCount, () {
              if (honorList != null) {
                NavigatorUtils.goHonorListPage(context, honorList);
              }
            }),
          ],
        ),
      ),
    );
  }
}

class UserHeaderChart extends StatelessWidget {
  final User userInfo;
  const UserHeaderChart(this.userInfo, {super.key});

  _renderChart(BuildContext context) {
    double height = 140;
    double width = 3 * MediaQuery.sizeOf(context).width / 2;
    if (userInfo.login != null && userInfo.type == 'Organization') {
      return Container();
    }
    return userInfo.login == null
        ? SizedBox(
            height: height,
            child: Center(
              child: SpinKitRipple(
                color: Theme.of(context).primaryColor,
              ),
            ),
          )
        : Card(
            margin: const EdgeInsets.only(left: 10, right: 10),
            color: GSYColors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                width: width,
                height: height,
                child: SvgPicture.network(
                  CommonUtils.getUserChartAddress(userInfo.login!),
                  width: width,
                  height: height - 10,
                  allowDrawingOutsideViewBox: true,
                  placeholderBuilder: (context) => SizedBox(
                    width: width,
                    height: height,
                    child: Center(
                      child: SpinKitRipple(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Container(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 15, bottom: 15, left: 12),
            alignment: Alignment.topLeft,
            child: Text(
              userInfo.type == 'Organization' ? localization.user_dynamic_group : localization.user_dynamic_title,
              style: GSYConstant.normalTextBold,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _renderChart(context),
        ],
      ),
    );
  }
}
