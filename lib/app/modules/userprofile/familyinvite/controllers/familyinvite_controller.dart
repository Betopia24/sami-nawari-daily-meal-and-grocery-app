import 'package:get/get.dart';
import '../../widgets/family_member_card.dart';

class FamilyMemberModel {
  final String name;
  final String detail;
  final String? imageUrl;
  final FamilyMemberRole role;

  FamilyMemberModel({
    required this.name,
    required this.detail,
    this.imageUrl,
    required this.role,
  });
}

class FamilyinviteController extends GetxController {
  final members = <FamilyMemberModel>[
    FamilyMemberModel(
      name: 'Rafiul Islam (You)',
      detail: 'rafi@email.com',
      role: FamilyMemberRole.owner,
    ),
    FamilyMemberModel(
      name: 'James Johnson',
      detail: 'james@email.com',
      role: FamilyMemberRole.editor,
    ),
    FamilyMemberModel(
      name: 'Amara Johnson',
      detail: 'Child account',
      role: FamilyMemberRole.viewer,
    ),
  ].obs;

  void saveChanges() {
    Get.back();
  }

  void inviteMember() {
    // Logic to invite a new member
  }

  void showMemberOptions(FamilyMemberModel member) {
    // Show bottom sheet with options
  }
}
