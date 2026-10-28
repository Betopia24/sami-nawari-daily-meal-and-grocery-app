import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/utils/app_colors.dart';

class OrderStatusTracker extends StatefulWidget {
  final String currentStatus;
  final Function(String) onConfirm;
  final bool isLoading;

  const OrderStatusTracker({
    super.key,
    required this.currentStatus,
    required this.onConfirm,
    this.isLoading = false,
  });

  @override
  State<OrderStatusTracker> createState() => _OrderStatusTrackerState();
}

class _OrderStatusTrackerState extends State<OrderStatusTracker> {
  final List<String> steps = [
    'Accepted',
    'Preparing',
    'Out for Delivery',
    'Delivered',
    'Completed'
  ];

  String? _selectedNextStep;

  int _indexOf(String s) {
    final clean = s.toUpperCase().replaceAll(' ', '_');
    switch (clean) {
      case 'ACCEPTED':
        return 0;
      case 'PREPARING':
        return 1;
      case 'OUT_FOR_DELIVERY':
      case 'ON_THE_WAY':
        return 2;
      case 'DELIVERED':
        return 3;
      case 'COMPLETED':
        return 4;
      default:
        return -1;
    }
  }

  bool _isStepCompleted(String step) {
    final cur = _indexOf(widget.currentStatus);
    final target = _indexOf(step);
    return cur >= target && cur >= 0;
  }

  bool _isStepSelected(String step) {
    return _selectedNextStep == step;
  }

  void _toggleStep(String step) {
    if (widget.isLoading) return;

    // Determine the immediate next step
    final currentIndex = _indexOf(widget.currentStatus);
    final targetIndex = _indexOf(step);

    // Can only select the immediate next step
    if (targetIndex != currentIndex + 1) return;

    setState(() {
      if (_selectedNextStep == step) {
        _selectedNextStep = null; // uncheck
      } else {
        _selectedNextStep = step;
      }
    });
  }

  Widget _buildStep(String title, {String? time}) {
    final isCompleted = _isStepCompleted(title);
    final isSelected = _isStepSelected(title);
    final isChecked = isCompleted || isSelected;

    final currentIndex = _indexOf(widget.currentStatus);
    final targetIndex = _indexOf(title);
    final isLocked = targetIndex > currentIndex + 1;

    return GestureDetector(
      onTap: () => _toggleStep(title),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isChecked ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isChecked
                      ? AppColors.primary
                      : (isLocked
                          ? AppColors.borderGrey.withValues(alpha: 0.5)
                          : AppColors.borderGrey),
                ),
              ),
              child: isChecked
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isLocked
                        ? AppColors.textSecondary.withValues(alpha: 0.5)
                        : AppColors.textPrimary,
                  ),
                ),
                if (time != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final curIndex = _indexOf(widget.currentStatus);
    final isCompletedAll = curIndex == 4;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Status',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.borderGrey),
          const SizedBox(height: 16),
          _buildStep('Accepted',
              time: _isStepCompleted('Accepted') ? 'Accepted' : null),
          _buildStep('Preparing',
              time: _isStepCompleted('Preparing') ? 'Kitchen' : null),
          _buildStep('Out for Delivery',
              time: _isStepCompleted('Out for Delivery') ? 'On Way' : null),
          _buildStep('Delivered',
              time: _isStepCompleted('Delivered') ? 'Delivered' : null),
          _buildStep('Completed',
              time: _isStepCompleted('Completed') ? 'Finished' : null),
          if (!isCompletedAll) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: (_selectedNextStep != null && !widget.isLoading)
                    ? () {
                        widget.onConfirm(_selectedNextStep!);
                        setState(() {
                          _selectedNextStep = null;
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: const Color(0xFFF3F4F6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: widget.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Confirm',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _selectedNextStep != null
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
