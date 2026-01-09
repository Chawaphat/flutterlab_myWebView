import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyWebView(),
    );
  }
}

class MyWebView extends StatefulWidget {
  const MyWebView({super.key});

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  late final WebViewController controller;
  late final WebViewController controller1;
  late final WebViewController controller2;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadFlutterAsset('assets/index.html');

    controller1 = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(
        "<html><head><title>Local HTML String</title></head><body><h1>This is a local HTML string</h1><p>Hello from the local HTML string!</p></body></html>",
      );

    controller2 = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://flutter.dev') ||
                request.url.startsWith('https://docs.flutter.dev')) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://flutter.dev'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Web View'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (await controller.canGoBack()) {
                controller.goBack();
                controller1.goBack();
                controller2.goBack();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () async {
              if (await controller.canGoForward()) {
                controller.goForward();
                controller1.goForward();
                controller2.goForward();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.reload();
              controller1.reload();
              controller2.reload();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: WebViewWidget(controller: controller)),
          const Divider(height: 1),
          Expanded(child: WebViewWidget(controller: controller1)),
          const Divider(height: 1),
          Expanded(child: WebViewWidget(controller: controller2)),

          if (isLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
