import 'dart:async';

import 'package:easacc/components/custom-text-field.dart';
import 'package:easacc/components/webView-navigation-control.dart';
import 'package:easacc/helper/show-snack-bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {
  WebViewPage({super.key, required this.url});
  String url;
  // String _pageTitle = 'WebView Page';

  @override
  Widget build(BuildContext context) {
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            const CircularProgressIndicator();
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            showSnackBar(context, error.description);
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Web Page"),
          backgroundColor: const Color(0xFF143D59),
          actions: [
          NavigationControls(webViewController: controller),
    ],),
      body: Column(children: [
        Expanded(
            child: WebViewWidget(
                controller: controller,
            )
        )
      ])
    );
  }
}
