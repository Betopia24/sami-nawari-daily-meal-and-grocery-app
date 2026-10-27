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
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfilePasswordField(
                label: 'Current Password',
                hintText: '********',
                controller: controller.currentPasswordController,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Current password is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ProfilePasswordField(
                label: 'New Password',
                hintText: 'Min. 8 characters',
                controller: controller.newPasswordController,
                validator: controller.validateNewPassword,
              ),
              const SizedBox(height: 24),
              ProfilePasswordField(
                label: 'Confirm Password',
                hintText: 'Re-enter your new password',
                controller: controller.confirmPasswordController,
                validator: controller.validateConfirmPassword,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ProfileBottomButton(
        text: 'Update Password',
        onPressed: controller.saveChanges,
      ),
    );
  }
}
