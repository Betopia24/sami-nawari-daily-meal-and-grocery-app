import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/utils/app_colors.dart';
import 'package:daily_meal_and_grocery_app/app/modules/cart/mycarts/controllers/mycarts_controller.dart';

class StripePaymentView extends StatefulWidget {
  final String checkoutUrl;
  final String orderId;
  final String orderNumber;
  final String restaurantName;
  final String restaurantImage;
  final String itemsCountText;
  final String priceText;

  const StripePaymentView({
    super.key,
    required this.checkoutUrl,
    required this.orderId,
    required this.orderNumber,
    required this.restaurantName,
    required this.restaurantImage,
    required this.itemsCountText,
    required this.priceText,
  });

  @override
  State<StripePaymentView> createState() => _StripePaymentViewState();
}

class _StripePaymentViewState extends State<StripePaymentView> {
  late final WebViewController _webViewController;
  double _loadProgress = 0.0;
  bool _isLoading = true;
  bool _isNavigatingAway = false;
  bool _hasWebviewError = false;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    try {
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.white)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (progress) {
              if (mounted) {
                setState(() {
                  _loadProgress = progress / 100.0;
                  if (progress >= 100) {
                    _isLoading = false;
                  }
                });
              }
            },
            onPageStarted: (url) {
              if (mounted) {
                setState(() => _isLoading = true);
              }
              _checkRedirect(url);
            },
            onPageFinished: (url) {
              if (mounted) {
                setState(() => _isLoading = false);
              }
              _checkRedirect(url);
            },
            onNavigationRequest: (request) {
              final handled = _checkRedirect(request.url);
              if (handled) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
            onWebResourceError: (error) {
              debugPrint('WebView resource error: ${error.description}');
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.checkoutUrl));
    } catch (e) {
      debugPrint('Error initializing WebView: $e');
      if (mounted) {
        setState(() {
          _hasWebviewError = true;
          _isLoading = false;
        });
      }
    }
  }

  bool _checkRedirect(String url) {
    if (_isNavigatingAway) return true;

    final lower = url.toLowerCase();

    // CASE A: Success redirect (/api/v1/payments/success?session_id=...)
    if (lower.contains('/payments/success')) {
      _isNavigatingAway = true;
      _handlePaymentSuccess();
      return true;
    }

    // CASE B: Cancel redirect (/api/v1/payments/cancel)
    if (lower.contains('/payments/cancel')) {
      _isNavigatingAway = true;
      _handlePaymentCancelled();
      return true;
    }

    return false;
  }

  void _handlePaymentSuccess() {
    // Refresh user's cart & order list in memory
    if (Get.isRegistered<MycartsController>()) {
      final mc = Get.find<MycartsController>();
      mc.fetchCart();
      mc.fetchOrders();
    }

    Get.snackbar(
      'Payment Successful',
      'Your payment has been received and order confirmed.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );

    Get.offAllNamed(
      '/orderplaced',
      arguments: {
        'orderId': widget.orderId,
        'orderNumber': widget.orderNumber,
        'restaurantName': widget.restaurantName,
        'restaurantImage': widget.restaurantImage,
        'itemsCountText': widget.itemsCountText,
        'priceText': widget.priceText,
        'paymentMethodTitle': 'Payment Method',
        'paymentMethodSubtitle': 'Online (Stripe - Paid)',
        'isOnline': true,
        'isSuccess': true,
        'paymentStatus': 'PAID',
      },
    );
  }

  void _handlePaymentCancelled() {
    if (Get.isRegistered<MycartsController>()) {
      final mc = Get.find<MycartsController>();
      mc.fetchCart();
      mc.fetchOrders();
    }

    Get.snackbar(
      'Payment Cancelled',
      'The payment session was cancelled. You can retry paying below.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orangeAccent,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );

    Get.offAllNamed(
      '/orderplaced',
      arguments: {
        'orderId': widget.orderId,
        'orderNumber': widget.orderNumber,
        'restaurantName': widget.restaurantName,
        'restaurantImage': widget.restaurantImage,
        'itemsCountText': widget.itemsCountText,
        'priceText': widget.priceText,
        'paymentMethodTitle': 'Payment Method',
        'paymentMethodSubtitle': 'Online (Stripe - Incomplete)',
        'isOnline': true,
        'isSuccess': false,
        'paymentStatus': 'UNPAID',
      },
    );
  }

  Future<bool> _onWillPop() async {
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Cancel Payment?',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to exit the payment screen? Your order has been placed and you can retry paying at any time.',
          style: GoogleFonts.outfit(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Continue Payment',
              style: GoogleFonts.outfit(color: AppColors.primary, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Exit',
              style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (shouldLeave == true) {
      _handlePaymentCancelled();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _onWillPop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: _onWillPop,
          ),
          title: Row(
            children: [
              const Icon(Icons.lock_rounded, color: Color(0xFF635BFF), size: 18),
              const SizedBox(width: 8),
              Text(
                'Stripe Checkout',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F5F7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  widget.priceText,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF635BFF),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            if (_isLoading)
              LinearProgressIndicator(
                value: _loadProgress > 0 ? _loadProgress : null,
                color: const Color(0xFF635BFF),
                backgroundColor: Colors.grey.shade100,
                minHeight: 3,
              ),
            Expanded(
              child: _hasWebviewError
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.open_in_browser_rounded,
                              size: 56,
                              color: Color(0xFF635BFF),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Complete Payment in Browser',
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap below to open Stripe’s secure checkout in your browser.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF635BFF),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () async {
                                final uri = Uri.parse(widget.checkoutUrl);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(
                                    uri,
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                              icon: const Icon(Icons.payment, size: 20),
                              label: Text(
                                'Open Stripe Checkout',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: _handlePaymentSuccess,
                              child: Text(
                                "I have completed payment",
                                style: GoogleFonts.outfit(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : WebViewWidget(controller: _webViewController),
            ),
          ],
        ),
      ),
    );
  }
}
