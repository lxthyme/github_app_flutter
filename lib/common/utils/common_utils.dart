import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommonUtils {
  static copy(String? data, BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    if (data != null) {
      Clipboard.setData(ClipboardData(text: data));
      Fluttertoast.showToast(msg: localization.option_share_copy_success);
    }
  }

  static launchOutURL(String? url, BuildContext context) async {
    final localization = AppLocalizations.of(context)!;
    if (url != null && await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      Fluttertoast.showToast(msg: '${localization.option_web_launcher_error}: $url');
    }
  }
}
