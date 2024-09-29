import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:safe_surf/services/moderation_service.dart';
import 'package:safe_surf/utils/yt_search_js_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

class YtWebview extends StatelessWidget {
  final String shortsBlockJS;

  YtWebview({super.key, required this.shortsBlockJS});

  final ModerationService _moderationService = ModerationService();

  void _handleJavaScriptHandler(String handlerName, List<dynamic> args,
      InAppWebViewController? controller) async {
    debugPrint('JS Handler called: $handlerName with args: $args');
    String text = args[0];

    bool isAppropriateText = await _moderationService.isAppropriateText(text);
    debugPrint('Moderation result for "$text": $isAppropriateText');

    if (handlerName == 'checkSearchSubmit') {
      debugPrint('$handlerName Checking search input: $text');
      if (!isAppropriateText) {
        controller?.evaluateJavascript(
            source: YtSearchJsUtils.clearSearchResults);
        _showToast(
            "Inappropriate text and content detected. Search results removed.");
      } else {
        controller?.evaluateJavascript(source: YtSearchJsUtils.submitSearch);
      }
    } else if (handlerName == 'checkSearchInput') {
      debugPrint('$handlerName Checking search input: $text');
      if (!isAppropriateText) {
        controller?.evaluateJavascript(
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
      body: InAppWebView(
        initialUrlRequest:
            URLRequest(url: WebUri.uri(Uri.parse('https://m.youtube.com'))),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          useShouldOverrideUrlLoading: true,
        ),
        onWebViewCreated: (InAppWebViewController controller) {
          controller.addJavaScriptHandler(
            handlerName: 'checkSearchInput',
            callback: (args) =>
                _handleJavaScriptHandler('checkSearchInput', args, controller),
          );
          controller.addJavaScriptHandler(
            handlerName: 'checkSearchSubmit',
            callback: (args) =>
                _handleJavaScriptHandler('checkSearchSubmit', args, controller),
          );
        },
        onLoadStop: (controller, url) async {
          await controller.evaluateJavascript(source: shortsBlockJS);
          await controller.evaluateJavascript(
              source: YtSearchJsUtils.interceptSearchInput);
        },
      ),
    );
  }
}
