import 'package:flutter/material.dart';
import '../../../../app/widgets/primary_button.dart';
import 'package:daily_meal_and_grocery_app/core/utils/app_colors.dart';

class ProfileBottomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ProfileBottomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundSecondary,
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 16.0,
        bottom: MediaQuery.of(context).padding.bottom + 16.0,
      ),
      child: PrimaryButton(text: text, onPressed: onPressed, showArrow: false),
    );
  }
}
