import 'package:flutter/material.dart';
import 'package:safe_surf/widgets/forbidden_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YtWebview extends StatefulWidget {
  final String shortsBlockJS;

  const YtWebview({super.key, required this.shortsBlockJS});

  @override
  YtWebviewState createState() => YtWebviewState();
}

class YtWebviewState extends State<YtWebview> {
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
            _controller.runJavaScript(widget.shortsBlockJS);
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
