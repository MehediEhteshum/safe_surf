import 'package:flutter/material.dart';
import 'package:safe_surf/widgets/forbidden_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YouTubeWebViewPage extends StatefulWidget {
  const YouTubeWebViewPage({super.key});

  @override
  YouTubeWebViewPageState createState() => YouTubeWebViewPageState();
}

class YouTubeWebViewPageState extends State<YouTubeWebViewPage> {
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
              // Block or hide Shorts elements

              var shortsTab = document.querySelectorAll("ytm-pivot-bar-item-renderer")[1];
              if (shortsTab) {
                shortsTab.style.display = "none";
              }
                
              setInterval(function() {
                var shortsPage = document.querySelector("shorts-page");
                if (shortsPage) {
                  shortsPage.style.display = "none";
                }
              }, 10000);

              setInterval(function() {
                var shortsSections = document.querySelectorAll("ytm-reel-shelf-renderer");
                if (shortsSections) {
                  shortsSections.forEach((shortsSection) => {
                    shortsSection.style.display = "none";
                  });
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
