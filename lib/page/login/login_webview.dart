import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gsy_app/common/style/gsy_style.dart';
import 'package:gsy_app/widget/gsy_common_option_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';

// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class LoginWebView extends StatefulWidget {
  final String url;
  final String title;
  const LoginWebView(this.url, this.title);

  @override
  State<LoginWebView> createState() => _LoginWebViewState();
}

class _LoginWebViewState extends State<LoginWebView> {
  late final WebViewController webVC;
  late final PlatformWebViewControllerCreationParams params;

  final FocusNode focusNode = FocusNode();
  bool isLoading = true;

  @override
  void initState() {
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    webVC = WebViewController.fromPlatformCreationParams(params);
    if (webVC.platform is AndroidWebViewController) {
      (webVC.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(true);
    }
    webVC
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
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
          onNavigationRequest: (request) {
            if (request.url.startsWith('gsygithubapp://authed')) {
              var code = Uri.parse(request.url).queryParameters['code'];
              debugPrint('-->code[2]: $code');
              Navigator.of(context).pop(code);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
        widget.url,
      ));

    super.initState();
  }

  _renderTitle() {
    if (widget.url.isEmpty) {
      return Text(widget.title);
    }

    return Row(
      children: [
        Expanded(
          child: Text(
            widget.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        GSYCommonOptionWidget(
          url: widget.url,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: _renderTitle(),
      ),
      body: Stack(children: [
        TextField(
          focusNode: focusNode,
        ),
        WebViewWidget(controller: webVC),
        if (isLoading)
          Center(
            child: Container(
              width: 200,
              height: 200,
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitDoubleBounce(
                    color: Theme.of(context).primaryColor,
                  ),
                  const Divider(
                    height: 10,
                  ),
                  Text(
                    localization.loading_text,
                    style: GSYConstant.middleText,
                  ),
                ],
              ),
            ),
          )
      ]),
    );
  }
}
