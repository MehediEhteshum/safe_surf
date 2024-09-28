import 'package:flutter/material.dart';
import 'package:safe_surf/pages/home.dart';
import 'package:safe_surf/pages/yt_no_shorts_webview.dart';
import 'package:safe_surf/pages/yt_shorts_blocked_webview.dart';
import 'package:safe_surf/utils/constants.dart';

class AppRoutes {
  static Route onGenerateRoutes(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case homeRoute:
        return _materialPageRoute(const HomePage(), routeSettings);
      case ytShortsBlockedWebRoute:
        return _materialPageRoute(
            const YtShortsBlockedWebview(), routeSettings);
      case ytNoShortsWebRoute:
        return _materialPageRoute(const YtNoShortsWebview(), routeSettings);
      default:
        return _materialPageRoute(const HomePage(), routeSettings);
    }
  }

  static Route _materialPageRoute(Widget page, RouteSettings routeSettings) {
    return MaterialPageRoute(
        settings: routeSettings, builder: (context) => page);
  }
}
