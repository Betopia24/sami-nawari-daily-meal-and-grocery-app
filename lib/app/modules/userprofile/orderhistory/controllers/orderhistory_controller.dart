import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../data/models/buyer_order_model.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';

class OrderhistoryController extends GetxController {
  final selectedTabIndex = 0.obs;
  final List<String> tabOptions = ['All', 'Active', 'Completed'];

  final RxBool isLoading = false.obs;
  final RxList<BuyerOrder> orders = <BuyerOrder>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  /// Calls GET Urls.orders ('/orders')
  Future<void> fetchOrders() async {
    isLoading.value = true;
    try {
      final response = await NetworkCaller.getRequest(Urls.orders);
      if (response.isSuccess && response.responseData != null) {
        final orderResponse =
            BuyerOrderResponseModel.fromJson(response.responseData);
        if (orderResponse.data != null) {
          orders.assignAll(orderResponse.data!.orders);
        }
      }
    } catch (e) {
      debugPrint('Error fetching buyer orders in OrderhistoryController: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<BuyerOrder> get filteredOrders {
    switch (selectedTabIndex.value) {
      case 1: // Active
        return orders.where((order) => order.isActive).toList();
      case 2: // Completed
        return orders.where((order) => order.isCompleted).toList();
      case 0: // All
      default:
        return orders;
    }
  }

  void onTabChanged(int index) {
    selectedTabIndex.value = index;
  }

  void trackOrder(BuyerOrder order) {
    // Navigate to active orders in My Carts/Orders
    Get.toNamed('/navbar', arguments: {'tab': 3, 'mycarts_tab': 1});
  }

  void reorder(BuyerOrder order) {
    Get.snackbar(
      'Reorder',
      'Items from order ${order.displayTitle} have been added to your cart.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
    );
  }

  void reviewOrder(BuyerOrder order) {
    final foodId = order.items.isNotEmpty ? order.items.first.foodId : '';
    final orderId = order.id;

    int currentRating = 0;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rate & Review',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  order.displayTitle,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starIndex = index + 1;
                    final isFilled = starIndex <= currentRating;
                    return IconButton(
                      icon: Icon(
                        isFilled
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: isFilled ? Colors.amber : Colors.grey.shade400,
                        size: 32,
                      ),
                      onPressed: () {
                        setModalState(() {
                          currentRating = starIndex;
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    if (currentRating == 0) {
                      Get.snackbar(
                        'Rating Required',
                        'Please select a rating from 1 to 5 stars',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.amber.shade700,
                        colorText: Colors.white,
                      );
                      return;
                    }
                    Get.back();
                    if (orderId.isNotEmpty && foodId.isNotEmpty) {
                      await NetworkCaller.postRequest(
                        Urls.reviews,
                        body: {
                          'orderId': orderId,
                          'foodId': foodId,
                          'rating': currentRating,
                          'comment': 'Great meal, really enjoyed it!',
                        },
                      );
                    }
                    Get.snackbar(
                      'Review Submitted',
                      'Thank you for your review!',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green.shade600,
                      colorText: Colors.white,
                    );
                  },
                  child: Text(
                    'Submit Review',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  void showOrderDetailsSheet(BuyerOrder order) {
    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: Get.height * 0.85,
        ),
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Details',
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order.orderNumber,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      order.formattedStatus,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 12),
              Text(
                'ITEMS',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 12),
              ...order.items.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundSecondary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${item.quantity}x',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.foodName,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        '\$${item.subtotal.toStringAsFixed(2)}',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              if (order.deliveryAddress != null) ...[
                Text(
                  'DELIVERY ADDRESS',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  order.deliveryAddress!.formattedAddress,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
              ],
              Text(
                'SUMMARY',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 10),
              _buildPriceRow('Subtotal', '\$${order.subTotal.toStringAsFixed(2)}'),
              if (order.deliveryFee > 0)
                _buildPriceRow(
                    'Delivery Fee', '\$${order.deliveryFee.toStringAsFixed(2)}'),
              if (order.tax > 0)
                _buildPriceRow('Tax', '\$${order.tax.toStringAsFixed(2)}'),
              if (order.discount > 0)
                _buildPriceRow(
                    'Discount', '-\$${order.discount.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              _buildPriceRow(
                'Total Price',
                '\$${order.totalPrice.toStringAsFixed(2)}',
                isTotal: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Get.back(),
                child: Text(
                  'Close',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
              color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: isTotal ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
