import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YocoPaymentWebView extends StatefulWidget {
  final String checkoutUrl;
  final String reference;

  const YocoPaymentWebView({
    super.key,
    required this.checkoutUrl,
    required this.reference,
  });

  @override
  _YocoPaymentWebViewState createState() => _YocoPaymentWebViewState();
}

class _YocoPaymentWebViewState extends State<YocoPaymentWebView> {
  late WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            print('Page started: $url');
            setState(() => _isLoading = true);
            _checkPaymentResult(url);
          },
          onPageFinished: (url) {
            print('Page finished: $url');
            setState(() => _isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  void _checkPaymentResult(String url) {
    print('Checking URL: $url');

    if (url.contains('/wallet/topup-success')) {
      print('Payment SUCCESS detected');
      Navigator.pop(context, {'success': true, 'message': 'Payment successful'});
    } else if (url.contains('/wallet/topup-cancel')) {
      print('Payment CANCELLED detected');
      Navigator.pop(context, {'success': false, 'message': 'Payment cancelled'});
    } else if (url.contains('/wallet/topup-failure')) {
      print('Payment FAILED detected');
      Navigator.pop(context, {'success': false, 'message': 'Payment failed'});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('YOCO Payment'),
      //   backgroundColor: Colors.teal,
      //   leading: IconButton(
      //     icon: const Icon(Icons.close),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      // ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            ),
        ],
      ),
    );
  }
}
