import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gsy_app/common/style/gsy_style.dart';
import 'package:gsy_app/model/SearchUserQL.dart';
import 'package:gsy_app/model/User.dart';
import 'package:gsy_app/model/UserOrg.dart';
import 'package:gsy_app/redux/gsy_state.dart';
import 'package:gsy_app/widget/gsy_card_item.dart';

class UserItem extends StatelessWidget {
  final UserItemVM userItemVM;
  final VoidCallback? onPressed;
  final bool needImage;
  const UserItem(
    this.userItemVM, {
    super.key,
    this.onPressed,
    this.needImage = true,
  });

  @override
  Widget build(BuildContext context) {
    var me = StoreProvider.of<GSYState>(context).state.userInfo!;
    Widget userImage = IconButton(
      padding: const EdgeInsets.all(0),
      onPressed: null,
      icon: ClipOval(
        child: FadeInImage.assetNetwork(
          placeholder: GSYICons.DEFAULT_USER_ICON,
          image: userItemVM.userPic ?? '',
          fit: BoxFit.fitWidth,
          width: 40,
          height: 40,
        ),
      ),
    );
    return Container(
      child: GSYCardItem(
        color: me.login == userItemVM.login
            ? Colors.amber
            : (userItemVM.login == 'CarGuo')
                ? Colors.pink
                : Colors.white,
        child: TextButton(
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 5,
              bottom: 10,
            ),
            child: Row(
              children: [
                if (userItemVM.index != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      userItemVM.index ?? '---',
                      style: GSYConstant.middleSubTextBold,
                    ),
                  ),
                userImage,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            userItemVM.userName ?? 'null',
                            style: GSYConstant.smallTextBold,
                          ),
                          if (userItemVM.followers != null)
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'followers: ${userItemVM.followers}',
                                  style: GSYConstant.smallSubText,
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (userItemVM.bio != null && userItemVM.bio!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            userItemVM.bio!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GSYConstant.smallText,
                          ),
                        ),
                      if (userItemVM.lang != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 5, right: 10),
                          child: Text(
                            userItemVM.lang ?? '--',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GSYConstant.smallSubText,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserItemVM {
  String? userPic;
  String? userName;
  String? bio;
  int? followers;
  String? login;
  String? lang;
  String? index;

  UserItemVM.fromMap(User user) {
    userName = user.login;
    userPic = user.avatar_url;
    followers = user.followers;
  }

  UserItemVM.fromQL(SearchUserQL userQL, int? index) {
    userName = userQL.name;
    userPic = userQL.avatarUrl;
    followers = userQL.followers;
    bio = userQL.bio;
    login = userQL.login;
    lang = userQL.lang;
    this.index = index.toString();
  }

  UserItemVM.fromOrgMap(UserOrg org) {
    userName = org.login;
    userPic = org.avatarUrl;
  }
}
