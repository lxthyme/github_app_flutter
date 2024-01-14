import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:gsy_app/common/utils/common_utils.dart';
import 'package:gsy_app/common/utils/navigator_utils.dart';
import 'package:gsy_app/env/config_wrapper.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DebugLabel {
  static bool hadShow = false;
  static OverlayEntry? _overlayEntry;

  static showDebugLabel(BuildContext context) async {
    if (!ConfigWrapper.of(context)!.debug!) {
      return false;
    }
    if (hadShow) {
      return false;
    }
    hadShow = true;
    final localization = AppLocalizations.of(context)!;
    var (version, platform) = await _getDeviceInfo();
    PackageInfo packInfo = await PackageInfo.fromPlatform();

    // var language = localization.locale.languageCode;
    var language = 'zh';
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    var overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(builder: (context) {
      return GlobalLabel(
          version: packInfo.version,
          deviceInfo: version,
          platform: platform,
          language: language);
    });
    overlayState.insert(_overlayEntry!);
  }

  static resetDebugLabel(BuildContext context) {
    hideDebugLabel();
    showDebugLabel(context);
  }

  static hideDebugLabel() {
    hadShow = false;
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }
}

Future<(String, String)> _getDeviceInfo() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return (androidInfo.version.sdkInt.toString(), "Android");
  }
  IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  String device = await CommonUtils.getDeviceInfo();
  return (iosInfo.systemVersion , device);
}

class GlobalLabel extends StatefulWidget {
  final String? version;
  final String? deviceInfo;
  final String? platform;
  final String? language;

  GlobalLabel({this.version, this.deviceInfo, this.platform, this.language});

  @override
  _GlobalLabelState createState() => _GlobalLabelState();
}

class _GlobalLabelState extends State<GlobalLabel> {
  bool doubleClick = false;
  bool longClick = false;

  @override
  void dispose() {
    DebugLabel.hadShow = false;
    //_overlayEntry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        child: Material(
          color: Colors.transparent,
          child: Container(
            child: InkWell(
              onLongPress: () {
                longClick = true;
              },
              onDoubleTap: () {
                doubleClick = true;
                if (longClick && doubleClick) {
                  NavigatorUtils.goDebugDataPage(context);
                }
              },
              child: Text(
                "${widget.platform} ${widget.deviceInfo} ${widget.language} ${widget.version}",
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
          ),
        ),
        alignment: Alignment(0.97, 0.8),
      );
    });
  }
}
