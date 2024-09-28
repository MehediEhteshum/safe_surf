import 'package:flutter/material.dart';
import 'package:safe_surf/widgets/forbidden_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YtShortsBlockedWebview extends StatefulWidget {
  const YtShortsBlockedWebview({super.key});

  @override
  YtShortsBlockedWebviewState createState() => YtShortsBlockedWebviewState();
}

class YtShortsBlockedWebviewState extends State<YtShortsBlockedWebview> {
  late final WebViewController _controller;
  bool _showForbiddenPage = false;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('youtube') &&
                request.url.contains('shorts')) {
              setState(() {
                _showForbiddenPage = true;
              });
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageFinished: (String url) {
            // Inject JavaScript to detect Shorts dynamically
            _controller.runJavaScript('''
              // Block Shorts Page

              setInterval(function() {
                var isShortsPage = window.location.href.includes('shorts');
                if (isShortsPage) {
                  document.querySelector("shorts-page").remove();
                }
              }, 5000);
            ''');
          },
        ),
      )
      ..loadRequest(Uri.parse('https://m.youtube.com'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube'),
      ),
      body: _showForbiddenPage
          ? const ForbiddenView()
          : WebViewWidget(
              controller: _controller,
            ),
    );
  }
}
