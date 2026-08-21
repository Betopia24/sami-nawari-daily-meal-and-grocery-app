import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/custom_back_button.dart';
import 'package:daily_meal_and_grocery_app/core/utils/app_colors.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? actionWidget;

  const ProfileAppBar({super.key, required this.title, this.actionWidget});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundSecondary,
      elevation: 0,
      centerTitle: false,
      titleSpacing: 16,
      leadingWidth: 64,
      leading: Padding(
        padding: const EdgeInsets.only(left: 24.0),
        child: Center(child: const CustomBackButton()),
      ),
      title: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF222222),
        ),
      ),
      actions: actionWidget != null
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(child: actionWidget!),
              ),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
