import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../widgets/custom_back_button.dart';
import '../controllers/notification_controller.dart';
import '../widgets/notification_card.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 72,
        leading: const Padding(
          padding: EdgeInsets.only(left: 20, top: 8, bottom: 8),
          child: CustomBackButton(
            backgroundColor: Colors.white,
            hasBorder: true,
          ),
        ),
        title: Text(
          'Notifications',
          style: GoogleFonts.outfit(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Search field
            TextField(
              decoration: InputDecoration(
                hintText: 'Search notifications...',
                hintStyle: GoogleFonts.outfit(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SvgPicture.asset(
                    'assets/icons/search_icon.svg',
                    colorFilter: const ColorFilter.mode(
                      AppColors.textSecondary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColors.borderLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Filters
            SizedBox(
              height: 36,
              child: Obx(
                () {
                  final currentSelection = controller.selectedFilter.value;
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.filters.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final filter = controller.filters[index];
                      final isSelected = currentSelection == filter;

                      return GestureDetector(
                        onTap: () => controller.setFilter(filter),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: isSelected
                                ? null
                                : Border.all(color: AppColors.borderLight),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            filter,
                            style: GoogleFonts.outfit(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            // Notifications List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 24),
                children: const [
                  NotificationCard(
                    title: 'Order Update — Maria\'s Kitchen',
                    description:
                        'Your Mezze Platter is being prepared! Ready in ~20 minutes.',
                    emoji: '🍽️',
                    type: 'Order',
                    time: '5 min ago',
                    isUnread: true,
                  ),
                  NotificationCard(
                    title: 'New Recipe Suggestion',
                    description:
                        'Try this week\'s trending: Thai Green Curry - 35 min, 4.7 ⭐',
                    emoji: '📖',
                    type: 'Recipe',
                    time: '3h ago',
                    isUnread: true,
                  ),
                  NotificationCard(
                    title: 'Low Stock Alert',
                    description:
                        'You\'re running low on olive oil. Add it to your list.',
                    emoji: '🛒',
                    type: 'Grocery',
                    time: '1h ago',
                    isUnread: true,
                  ),
                  NotificationCard(
                    title: 'James Added Items',
                    description:
                        'James added 3 items to "Family Dinner Party List"',
                    emoji: '👨‍👩‍👦',
                    type: 'Family',
                    time: 'Yesterday',
                  ),
                  NotificationCard(
                    title: 'Maria\'s Kitchen - Weekend Special',
                    description:
                        'Fresh mezze platters available this Saturday. Pre-order now!',
                    emoji: '🏪',
                    type: 'Marketplace',
                    time: 'Yesterday',
                  ),
                  NotificationCard(
                    title: 'Leave a review',
                    description:
                        'How were your dumplings from Chen\'s Dim Sum? Share your experience!',
                    emoji: '⭐',
                    type: 'Order',
                    time: '2 days ago',
                  ),
                  NotificationCard(
                    title: 'Lunch Reminder',
                    description:
                        'Don\'t skip lunch! Your Shakshuka takes only 30 minutes.',
                    emoji: '🍳',
                    type: 'Meal',
                    time: '3 days ago',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

