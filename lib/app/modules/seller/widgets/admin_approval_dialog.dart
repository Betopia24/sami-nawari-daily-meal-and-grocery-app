import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../widgets/primary_button.dart';

/// Modal dialog shown when a user's seller application is pending admin approval
class AdminApprovalDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onCheckStatus;
  final VoidCallback? onDismiss;

  const AdminApprovalDialog({
    super.key,
    this.title = 'Pending Admin Approval',
    this.message =
        'Your seller registration has been submitted. Please wait for an administrator to review and approve your account. Once approved, you will be able to access the seller dashboard.',
    this.onCheckStatus,
    this.onDismiss,
  });

  /// Static helper to display the dialog
  static Future<void> show({
    String? title,
    String? message,
    VoidCallback? onCheckStatus,
    VoidCallback? onDismiss,
  }) {
    return Get.dialog(
      AdminApprovalDialog(
        title: title ?? 'Pending Admin Approval',
        message: message ??
            'Your seller registration has been submitted. Please wait for an administrator to review and approve your account. Once approved, you will be able to access the seller dashboard.',
        onCheckStatus: onCheckStatus,
        onDismiss: onDismiss,
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.hourglass_top_rounded,
                color: Color(0xFFD97706),
                size: 38,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.access_time_filled, size: 14, color: Colors.amber.shade800),
                  const SizedBox(width: 6),
                  Text(
                    'Admin Review in Progress',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.amber.shade900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            if (onCheckStatus != null) ...[
              PrimaryButton(
                text: 'Check Approval Status',
                onPressed: onCheckStatus!,
                showArrow: false,
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: onDismiss ?? () => Get.back(),
                child: Text(
                  'Dismiss',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ] else ...[
              PrimaryButton(
                text: 'Understood',
                onPressed: onDismiss ?? () => Get.back(),
                showArrow: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
