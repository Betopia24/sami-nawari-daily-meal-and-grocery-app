import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../app/widgets/primary_button.dart';
import 'package:daily_meal_and_grocery_app/core/utils/app_colors.dart';

class ProfileBottomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const ProfileBottomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
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
      child: isLoading
          ? Container(
              height: 51,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: SpinKitCircle(
                  color: Colors.white,
                  size: 32.0,
                ),
              ),
            )
          : PrimaryButton(
              text: text,
              onPressed: onPressed,
              showArrow: false,
            ),
    );
  }
}
