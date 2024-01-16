import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gsy_app/common/style/gsy_style.dart';
import 'package:gsy_app/widget/gsy_common_option_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:gsy_app/l10n/gen_l10n/app_localizations.dart';

class GSYWebView extends StatefulWidget {
  final String url;
  final String? title;
  const GSYWebView(this.url, this.title);

  @override
  State<GSYWebView> createState() => _GSYWebViewState();
}

class _GSYWebViewState extends State<GSYWebView> {
  final FocusNode focusNode = FocusNode();
  bool isLoading = true;
  late final WebViewController webVC;

  @override
  void initState() {
    webVC = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            // Update loading bar.
          },
          onPageStarted: (url) {},
          onPageFinished: (url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (error) {},
        ),
      )
      ..addJavaScriptChannel(
        'name',
        onMessageReceived: (p0) {
          print(p0.message);
          FocusScope.of(context).requestFocus(focusNode);
        },
      )
      ..loadRequest(Uri.parse(widget.url));

    super.initState();
  }

  _renderTitle() {
    if (widget.url.isEmpty) {
      return Text(widget.title ?? '--');
    }
    return Row(
      children: [
        Expanded(
          child: Container(
            child: Text(
              widget.title ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        GSYCommonOptionWidget(url: widget.url),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: GSYColors.mainBackgroundColor,
      appBar: AppBar(
        title: _renderTitle(),
      ),
      body: Stack(
        children: [
          TextField(
            focusNode: focusNode,
          ),
          WebViewWidget(controller: webVC),
          if (isLoading)
            Center(
              child: Container(
                width: 200,
                height: 200,
                padding: const EdgeInsets.all(4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitDoubleBounce(
                      color: Theme.of(context).primaryColor,
                    ),
                    // Container(width: 10),
                    const Divider(height: 10),
                    Text(
                      localization.loading_text,
                      style: GSYConstant.middleText,
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
