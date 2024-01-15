import 'package:flutter/material.dart';
// import 'package:gsy_app/common/dao/issue_dao.dart';
import 'package:gsy_app/common/net/interceptors/log_interceptor.dart';
import 'package:gsy_app/common/style/gsy_style.dart';
import 'package:gsy_app/common/utils/common_utils.dart';

class ErrorPage extends StatefulWidget {
  final String errorMessage;
  final FlutterErrorDetails details;

  ErrorPage(this.errorMessage, this.details);

  @override
  ErrorPageState createState() => ErrorPageState();
}

class ErrorPageState extends State<ErrorPage> {
  static List<Map<String, dynamic>?> sErrorStack = [];
  static List<String?> sErrorName = [];

  final TextEditingController textEditingController =
      TextEditingController();

  addError(FlutterErrorDetails details) {
    try {
      var map = Map<String, dynamic>();
      map["error"] = details.toString();
      LogsInterceptors.addLogic(
          sErrorName, details.exception.runtimeType.toString());
      LogsInterceptors.addLogic(sErrorStack, map);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width =
        MediaQueryData.fromView(View.of(context)).size.width;
    return Container(
      color: GSYColors.primaryValue,
      child: Center(
        child: Container(
          alignment: Alignment.center,
          width: width,
          height: width,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(30),
            gradient:
                RadialGradient(tileMode: TileMode.mirror, radius: 0.1, colors: [
              Colors.white.withAlpha(10),
              GSYColors.primaryValue.withAlpha(100),
            ]),
            borderRadius: BorderRadius.all(Radius.circular(width / 2)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
             Image(
                  image: AssetImage(GSYICons.DEFAULT_USER_ICON, package: 'gsy_app'),
                  width: 90.0,
                  height: 90.0),
              SizedBox(
                height: 11,
              ),
              Material(
                child: Text(
                  "Error Occur",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                color: GSYColors.primaryValue,
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: GSYColors.white.withAlpha(100),
                    ),
                    onPressed: () {
                      // String content = widget.errorMessage;
                      // textEditingController.text = content;
                      // CommonUtils.showEditDialog(
                      //     context,
                      //     GSYLocalizations.i18n(context)!.home_reply,
                      //     (title) {}, (res) {
                      //   content = res;
                      // }, () {
                      //   if (content.length == 0) {
                      //     return;
                      //   }
                      //   CommonUtils.showLoadingDialog(context);
                      //   IssueDao.createIssueDao(
                      //       "CarGuo", "gsy_github_app_flutter", {
                      //     "title": GSYLocalizations.i18n(context)!.home_reply,
                      //     "body": content
                      //   }).then((result) {
                      //     Navigator.pop(context);
                      //     Navigator.pop(context);
                      //   });
                      // },
                      //     titleController: TextEditingController(),
                      //     valueController: textEditingController,
                      //     needTitle: false);
                    },
                    child: Text("Report"),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.white.withAlpha(100)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Back")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
