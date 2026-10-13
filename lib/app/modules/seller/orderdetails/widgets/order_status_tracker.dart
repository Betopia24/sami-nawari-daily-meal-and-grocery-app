import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/utils/app_colors.dart';

class OrderStatusTracker extends StatefulWidget {
  final String currentStatus;
  final Function(String) onConfirm;

  const OrderStatusTracker({
    Key? key,
    required this.currentStatus,
    required this.onConfirm,
  }) : super(key: key);

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

  bool _isStepCompleted(String step) {
    return steps.indexOf(widget.currentStatus) >= steps.indexOf(step);
  }

  bool _isStepSelected(String step) {
    return _selectedNextStep == step;
  }

  void _toggleStep(String step) {
    // Determine the immediate next step
    final currentIndex = steps.indexOf(widget.currentStatus);
    final targetIndex = steps.indexOf(step);
    
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

    final currentIndex = steps.indexOf(widget.currentStatus);
    final targetIndex = steps.indexOf(title);
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
                  color: isChecked ? AppColors.primary : (isLocked ? AppColors.borderGrey.withOpacity(0.5) : AppColors.borderGrey),
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
                    color: isLocked ? AppColors.textSecondary.withOpacity(0.5) : AppColors.textPrimary,
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
          // For demo purposes, we show a time for 'Accepted' if it's completed
          _buildStep('Accepted', time: _isStepCompleted('Accepted') ? '02:42 PM' : null),
          _buildStep('Preparing', time: _isStepCompleted('Preparing') ? '03:00 PM' : null),
          _buildStep('Out for Delivery', time: _isStepCompleted('Out for Delivery') ? '03:15 PM' : null),
          _buildStep('Delivered', time: _isStepCompleted('Delivered') ? '03:45 PM' : null),
          _buildStep('Completed', time: _isStepCompleted('Completed') ? '03:50 PM' : null),
          if (widget.currentStatus != 'Completed') ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _selectedNextStep != null
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
                child: Text(
                  'Confirm',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _selectedNextStep != null ? Colors.white : AppColors.textSecondary,
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
