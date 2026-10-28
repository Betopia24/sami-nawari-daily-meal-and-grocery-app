import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../widgets/custom_back_button.dart';

class StripeWebViewScreen extends StatefulWidget {
  final String url;
  final String title;
  final VoidCallback? onComplete;

  const StripeWebViewScreen({
    super.key,
    required this.url,
    this.title = 'Stripe Onboarding',
    this.onComplete,
  });

  @override
  State<StripeWebViewScreen> createState() => _StripeWebViewScreenState();
}

class _StripeWebViewScreenState extends State<StripeWebViewScreen> {
  WebViewController? _controller;
  int _progress = 0;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initWebViewController();
  }

  void _initWebViewController() {
    try {
      final WebViewController controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              if (mounted) {
                setState(() {
                  _progress = progress;
                });
              }
            },
            onPageStarted: (String url) {
              if (mounted) {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });
              }
            },
            onPageFinished: (String url) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                  _progress = 100;
                });
              }
            },
            onWebResourceError: (WebResourceError error) {
              // Only treat main-frame errors as fatal
              if (error.isForMainFrame ?? true) {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                    _errorMessage = error.description;
                  });
                }
              }
            },
            onNavigationRequest: (NavigationRequest request) {
              final uri = Uri.tryParse(request.url);
              if (uri != null) {
                final path = uri.path.toLowerCase();
                if (path.contains('return') ||
                    path.contains('success') ||
                    path.contains('complete')) {
                  widget.onComplete?.call();
                }
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.url));

      _controller = controller;
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Could not initialize webview: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBFBFB),
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: CustomBackButton(
            backgroundColor: Colors.white,
            onTap: () => _handleBackPress(),
          ),
        ),
        title: Text(
          widget.title,
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          if (_controller != null)
            IconButton(
              icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
              tooltip: 'Reload',
              onPressed: () {
                _controller?.reload();
              },
            ),
          const SizedBox(width: 12),
        ],
        bottom: _isLoading && _progress < 100
            ? PreferredSize(
                preferredSize: const Size.fromHeight(3.0),
                child: LinearProgressIndicator(
                  value: _progress / 100.0,
                  backgroundColor: Colors.grey.withValues(alpha: 0.2),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 3,
                ),
              )
            : null,
      ),
      body: SafeArea(
        child: _errorMessage != null
            ? _buildErrorView()
            : (_controller != null
                ? WebViewWidget(controller: _controller!)
                : const Center(child: CircularProgressIndicator())),
      ),
    );
  }

  void _handleBackPress() {
    Get.back();
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                color: AppColors.error,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Unable to load page',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Please check your connection and try again.',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _errorMessage = null;
                  _isLoading = true;
                });
                _controller?.reload();
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
