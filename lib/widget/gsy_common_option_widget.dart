import 'package:flutter/material.dart';
import 'package:gsy_app/common/style/gsy_style.dart';
import 'package:gsy_app/l10n/gen_l10n/app_localizations.dart';
import 'package:gsy_app/common/utils/common_utils.dart';
import 'package:share_plus/share_plus.dart';

class GSYCommonOptionWidget extends StatelessWidget {
  final List<GSYOptionModel>? otherList;
  final String? url;
  const GSYCommonOptionWidget({
    super.key,
    this.otherList,
    String? url,
  }) : url = (url == null) ? GSYConstant.app_default_share_url : url;

  _renderHeaderPopItem(List<GSYOptionModel> list) {
    return PopupMenuButton<GSYOptionModel>(
      child: Icon(GSYICons.MORE),
      onSelected: (value) {
        value.selected(value);
      },
      itemBuilder: (context) {
        return _renderHeaderPopItem(list);
      },
    );
  }

  _renderHeaderPopItemChild(List<GSYOptionModel> data) {
    List<PopupMenuEntry<GSYOptionModel>> list = [];
    for (GSYOptionModel item in data) {
      list.add(
        PopupMenuItem<GSYOptionModel>(
          value: item,
          child: Text(item.name),
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    List<GSYOptionModel> constList = [
      GSYOptionModel(localization.option_web, localization.option_web,
          (model) {
        CommonUtils.launchOutURL(url, context);
      }),
      GSYOptionModel(localization.option_copy, localization.option_copy,
          (model) {
        CommonUtils.copy(url ?? "", context);
      }),
      GSYOptionModel(localization.option_share, localization.option_share,
          (model) {
        Share.share(localization.option_share_title + (url ?? ''));
      }),
    ];
    var list = [...constList, ...?otherList];
    return _renderHeaderPopItem(list);
  }
}

class GSYOptionModel {
  final String name;
  final String value;
  final PopupMenuItemSelected<GSYOptionModel> selected;

  const GSYOptionModel(this.name, this.value, this.selected);
}
