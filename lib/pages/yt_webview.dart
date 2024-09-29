import 'package:flutter/material.dart';
import 'package:safe_surf/widgets/forbidden_view.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:safe_surf/services/moderation_service.dart';
import 'package:safe_surf/utils/yt_search_js_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

class YtWebview extends StatefulWidget {
  final String shortsBlockJS;

  const YtWebview({super.key, required this.shortsBlockJS});

  @override
  State<YtWebview> createState() => _YtWebviewState();
}

class _YtWebviewState extends State<YtWebview> {
  bool _showForbiddenPage = false;
  final ModerationService _moderationService = ModerationService();
  InAppWebViewController? _webViewController;

  void _handleJavaScriptHandler(String handlerName, List<dynamic> args) async {
    debugPrint('JS Handler called: $handlerName with args: $args');
    String text = args[0];

    bool isAppropriate = await _moderationService.isAppropriateText(text);
    debugPrint('Moderation result for "$text": $isAppropriate');

    if (handlerName == 'checkSearchSubmit') {
      debugPrint('$handlerName Checking search input: $text');
      if (!isAppropriate) {
        _webViewController?.evaluateJavascript(
            source: YtSearchJsUtils.clearSearchInput);
        _showToast("Inappropriate text detected.");
      } else {
        _webViewController?.evaluateJavascript(
            source: YtSearchJsUtils.submitSearch);
      }
    } else if (handlerName == 'checkSearchInput') {
      debugPrint('$handlerName Checking search input: $text');
      if (!isAppropriate) {
        _webViewController?.evaluateJavascript(
            source: YtSearchJsUtils.clearSearchInput);
        _showToast("Inappropriate text detected.");
      }
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube'),
      ),
      body: _showForbiddenPage
          ? const ForbiddenView()
          : InAppWebView(
              initialUrlRequest: URLRequest(
                  url: WebUri.uri(Uri.parse('https://m.youtube.com'))),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                useShouldOverrideUrlLoading: true,
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                _webViewController = controller;
                controller.addJavaScriptHandler(
                  handlerName: 'checkSearchInput',
                  callback: (args) =>
                      _handleJavaScriptHandler('checkSearchInput', args),
                );
                controller.addJavaScriptHandler(
                  handlerName: 'checkSearchSubmit',
                  callback: (args) =>
                      _handleJavaScriptHandler('checkSearchSubmit', args),
                );
              },
              onLoadStop: (controller, url) async {
                await controller.evaluateJavascript(
                    source: widget.shortsBlockJS);
                await controller.evaluateJavascript(
                    source: YtSearchJsUtils.interceptSearchInput);
              },
            ),
    );
  }
}
