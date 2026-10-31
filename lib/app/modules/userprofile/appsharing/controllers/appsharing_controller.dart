import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../core/utils/app_strings.dart';

class AppsharingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  late Animation<double> rotationAnimation;

  String get appDownloadUrl => AppStrings.appDownloadUrl;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.elasticOut),
    );

    rotationAnimation = Tween<double>(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutBack),
    );

    animationController.forward();
  }

  Future<void> shareViaPackage({Rect? sharePositionOrigin}) async {
    try {
      await Share.share(
        AppStrings.shareAppMessage,
        subject: AppStrings.shareAppSubject,
        sharePositionOrigin: sharePositionOrigin,
      );
    } catch (e) {
      debugPrint('Error sharing via share_plus: $e');
    }
  }

  Future<void> copyLink({Rect? sharePositionOrigin}) async {
    try {
      await Clipboard.setData(
        const ClipboardData(text: AppStrings.appDownloadUrl),
      );
      Get.snackbar(
        'Copied',
        'Download link copied to clipboard',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      debugPrint('Error copying to clipboard: $e');
    }

    await shareViaPackage(sharePositionOrigin: sharePositionOrigin);
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
