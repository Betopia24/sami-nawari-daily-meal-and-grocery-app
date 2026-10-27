import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../widgets/custom_shimmer.dart';

/// Shimmer skeleton for PlaceorderView (Payment screen) during loading
class PaymentShimmer extends StatelessWidget {
  const PaymentShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title: Order Summary
          const CustomShimmer.rectangular(
            width: 130,
            height: 18,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          const SizedBox(height: 16),

          // Order Summary Card Shimmer
          _buildOrderSummaryCardShimmer(),
          const SizedBox(height: 24),

          // Section Title: Payment Summary
          const CustomShimmer.rectangular(
            width: 150,
            height: 18,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          const SizedBox(height: 16),

          // Payment Summary Card Shimmer
          _buildPaymentSummaryCardShimmer(),
          const SizedBox(height: 24),

          // Section Title: Payment Method
          const CustomShimmer.rectangular(
            width: 140,
            height: 18,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          const SizedBox(height: 6),
          const CustomShimmer.rectangular(
            width: 220,
            height: 12,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          const SizedBox(height: 16),

          // Option Card 1 (Online Pay)
          CustomShimmer.card(
            height: 76,
            radius: 16,
          ),
          const SizedBox(height: 12),

          // Option Card 2 (Cash on Delivery)
          CustomShimmer.card(
            height: 76,
            radius: 16,
          ),
          const SizedBox(height: 24),

          // Secure banner shimmer
          CustomShimmer.card(
            height: 52,
            radius: 12,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryCardShimmer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              CustomShimmer.circular(size: 40),
              SizedBox(width: 12),
              Expanded(
                child: CustomShimmer.rectangular(
                  width: 120,
                  height: 16,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ),
              CustomShimmer.rectangular(
                width: 70,
                height: 24,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              CustomShimmer.rectangular(
                width: 160,
                height: 14,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              CustomShimmer.rectangular(
                width: 50,
                height: 14,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              CustomShimmer.rectangular(
                width: 110,
                height: 14,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              CustomShimmer.rectangular(
                width: 45,
                height: 14,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummaryCardShimmer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              CustomShimmer.rectangular(
                width: 100,
                height: 14,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              CustomShimmer.rectangular(
                width: 50,
                height: 14,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              CustomShimmer.rectangular(
                width: 90,
                height: 14,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              CustomShimmer.rectangular(
                width: 45,
                height: 14,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              CustomShimmer.rectangular(
                width: 90,
                height: 14,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              CustomShimmer.rectangular(
                width: 40,
                height: 14,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, thickness: 1, color: AppColors.borderGrey),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              CustomShimmer.rectangular(
                width: 160,
                height: 16,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              CustomShimmer.rectangular(
                width: 60,
                height: 16,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
