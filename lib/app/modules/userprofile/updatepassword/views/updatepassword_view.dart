import 'package:daily_meal_and_grocery_app/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../widgets/profile_app_bar.dart';
import '../../widgets/profile_bottom_button.dart';
import '../../widgets/profile_password_field.dart';
import '../controllers/updatepassword_controller.dart';

class UpdatepasswordView extends GetView<UpdatepasswordController> {
  const UpdatepasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: const ProfileAppBar(title: 'Update Password'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfilePasswordField(
              label: 'Current Password',
              hintText: '********',
              controller: controller.currentPasswordController,
            ),
            const SizedBox(height: 24),
            ProfilePasswordField(
              label: 'New Password',
              hintText: 'Min. 8 characters',
              controller: controller.newPasswordController,
            ),
            const SizedBox(height: 24),
            ProfilePasswordField(
              label: 'Confirm Password',
              hintText: 'Re-enter your new password',
              controller: controller.confirmPasswordController,
            ),
          ],
        ),
      ),
      bottomNavigationBar: ProfileBottomButton(
        text: 'Update Password',
        onPressed: controller.saveChanges,
      ),
    );
  }
}
