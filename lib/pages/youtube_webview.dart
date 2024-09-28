import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YouTubeWebViewPage extends StatefulWidget {
  const YouTubeWebViewPage({super.key});

  @override
  YouTubeWebViewPageState createState() => YouTubeWebViewPageState();
}

class YouTubeWebViewPageState extends State<YouTubeWebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://m.youtube.com'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube'),
      ),
      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
