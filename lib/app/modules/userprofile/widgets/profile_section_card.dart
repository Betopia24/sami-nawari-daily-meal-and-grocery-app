import 'package:flutter/material.dart';
import 'package:daily_meal_and_grocery_app/core/utils/app_colors.dart';

class ProfileSectionCard extends StatelessWidget {
  final List<Widget> children;

  const ProfileSectionCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight, width: 1.05),
      ),
      child: Column(children: children),
    );
  }
}
