import 'package:easacc/helper/show-snack-bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NavigationControls extends StatelessWidget {
  const NavigationControls({super.key, required WebViewController webViewController}) : _webViewController = webViewController;

  final WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children:[
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            if (await _webViewController.canGoForward()) {
              await _webViewController.goForward();
            } else {
              if (context.mounted) {
                showSnackBar(context, 'No forward history item');
              }
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () async {
            if (await _webViewController.canGoBack()) {
              await _webViewController.goBack();
            } else {
              if (context.mounted) {
                showSnackBar(context, "No back history item");
              }
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.replay),
          onPressed: () => _webViewController.reload(),
        ),
      ],
    );
  }}