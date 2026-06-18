import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Result of a PayMob payment attempt
enum PayMobPaymentResult { success, failure, cancelled }

/// Screen that shows the PayMob payment iframe in a WebView
/// and returns the result when PayMob redirects after payment
class PayMobWebViewScreen extends StatefulWidget {
  final String paymentUrl;

  const PayMobWebViewScreen({super.key, required this.paymentUrl});

  @override
  State<PayMobWebViewScreen> createState() => _PayMobWebViewScreenState();
}

class _PayMobWebViewScreenState extends State<PayMobWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _resultHandled = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => _isLoading = true);
            _handleRedirect(url);
          },
          onPageFinished: (_) => setState(() => _isLoading = false),
          onNavigationRequest: (request) {
            _handleRedirect(request.url);
            return NavigationDecision.navigate;
          },
          onUrlChange: (change) {
            if (change.url != null) {
              _handleRedirect(change.url!);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _handleRedirect(String url) {
    if (_resultHandled) return;

    // PayMob redirects to the transaction result page after payment
    // Check the URL and query params for success/failure
    final uri = Uri.tryParse(url);
    if (uri == null) return;

    final success = uri.queryParameters['success'];

    // PayMob sends: success=true or success=false
    if (success != null) {
      _resultHandled = true;
      final result = success == 'true'
          ? PayMobPaymentResult.success
          : PayMobPaymentResult.failure;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.of(context).pop(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إتمام الدفع'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(PayMobPaymentResult.cancelled),
          tooltip: 'إلغاء الدفع',
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('جارٍ تحميل بوابة الدفع...'),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
