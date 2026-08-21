import 'package:daily_meal_and_grocery_app/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:daily_meal_and_grocery_app/core/utils/app_colors.dart';

class AnimatedNotificationHeader extends StatefulWidget {
  const AnimatedNotificationHeader({Key? key}) : super(key: key);

  @override
  State<AnimatedNotificationHeader> createState() =>
      _AnimatedNotificationHeaderState();
}

class _AnimatedNotificationHeaderState extends State<AnimatedNotificationHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bellScaleAnimation;
  late Animation<double> _cardScaleAnimation;
  late Animation<Offset> _card1OffsetAnimation;
  late Animation<Offset> _card2OffsetAnimation;
  late Animation<Offset> _card3OffsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Bell pops in first
    _bellScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
      ),
    );

    // Cards scale up together
    _cardScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.elasticOut),
      ),
    );

    // Cards translate from center
    _card1OffsetAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(-110, -85)).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.3, 0.8, curve: Curves.easeOutBack),
          ),
        );

    _card2OffsetAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(125, -45)).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.4, 0.9, curve: Curves.easeOutBack),
          ),
        );

    _card3OffsetAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(-95, 80)).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.5, 1.0, curve: Curves.easeOutBack),
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.38,
      width: double.infinity,
      color: AppColors.backgroundNotification,
      child: SafeArea(
        bottom: false,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background Circle
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.glowYellow.withOpacity(0.15),
              ),
            ),

            // Card 1: Breakfast
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: _card1OffsetAnimation.value,
                  child: Transform.scale(
                    scale: _cardScaleAnimation.value,
                    child: child,
                  ),
                );
              },
              child: _NotificationMiniCard(
                title: 'Breakfast reminder!',
                subtitle: 'It\'s time for Avocado Toast',
                iconColor: AppColors.textDark,
              ),
            ),

            // Card 2: Recipe
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: _card2OffsetAnimation.value,
                  child: Transform.scale(
                    scale: _cardScaleAnimation.value,
                    child: child,
                  ),
                );
              },
              child: _NotificationMiniCard(
                title: 'New recipe',
                subtitle: 'Try Thai Green Curry',
                iconColor: AppColors.textDark,
              ),
            ),

            // Card 3: List updated
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: _card3OffsetAnimation.value,
                  child: Transform.scale(
                    scale: _cardScaleAnimation.value,
                    child: child,
                  ),
                );
              },
              child: _NotificationMiniCard(
                title: 'List updated',
                subtitle: 'Emma added 3 items',
                iconColor: AppColors.textDark,
              ),
            ),

            // Central Bell
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _bellScaleAnimation.value,
                  child: child,
                );
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: AppColors.iconOrange,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.iconOrange.withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                  ),
                  // Notification Badge
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.backgroundNotification,
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '3',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
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

class _NotificationMiniCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color iconColor;

  const _NotificationMiniCard({
    required this.title,
    required this.subtitle,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: GoogleFonts.outfit(
                  color: AppColors.textDark,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: GoogleFonts.outfit(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
