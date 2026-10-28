import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../widgets/profile_app_bar.dart';
import '../../widgets/profile_bottom_button.dart';
import '../../widgets/family_member_card.dart';
import '../controllers/familyinvite_controller.dart';

class FamilyinviteView extends GetView<FamilyinviteController> {
  const FamilyinviteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: ProfileAppBar(
        title: 'Family Members',
        actionWidget: GestureDetector(
          onTap: controller.inviteMember,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Invite',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'MEMBERS',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade500,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => Column(
                children: controller.members.map((member) {
                  return FamilyMemberCard(
                    name: member.name,
                    detail: member.detail,
                    imageUrl: member.imageUrl,
                    role: member.role,
                    onMoreTap: () => controller.showMemberOptions(member),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ProfileBottomButton(
        text: 'Save Changes',
        onPressed: controller.saveChanges,
      ),
    );
  }
}
