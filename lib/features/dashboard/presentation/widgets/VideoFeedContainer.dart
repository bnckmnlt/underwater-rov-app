import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VideoFeedContainer extends StatefulWidget {
  const VideoFeedContainer({super.key});

  @override
  State<VideoFeedContainer> createState() => _VideoFeedContainerState();
}

class _VideoFeedContainerState extends State<VideoFeedContainer> {
  final WebViewController _videoController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.disabled)
    ..loadRequest(Uri.parse('http://192.168.22.216:8080/video_feed'));

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _videoController);
  }
}
