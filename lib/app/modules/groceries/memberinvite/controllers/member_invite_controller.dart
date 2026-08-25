import 'package:get/get.dart';

class FamilyMember {
  final String id;
  final String name;
  final String email;
  final String avatarPath;
  bool isSelected;

  FamilyMember({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarPath,
    this.isSelected = false,
  });
}

class MemberInviteController extends GetxController {
  final familyMembers = <FamilyMember>[
    FamilyMember(
      id: '1',
      name: 'James',
      email: 'james@gmail.com',
      avatarPath: '',
      isSelected: false,
    ),
    FamilyMember(
      id: '2',
      name: 'Amara',
      email: 'amara@gmail.com',
      avatarPath: '',
      isSelected: false,
    ),
    FamilyMember(
      id: '3',
      name: 'Smith',
      email: 'smith@gmail.com',
      avatarPath: '',
      isSelected: false,
    ),
    FamilyMember(
      id: '4',
      name: 'Liza',
      email: 'liza@gmail.com',
      avatarPath: '',
      isSelected: false,
    ),
    FamilyMember(
      id: '5',
      name: 'Fahad',
      email: 'fahad@gmail.com',
      avatarPath: '',
      isSelected: false,
    ),
  ].obs;

  void toggleSelection(String id) {
    final index = familyMembers.indexWhere((m) => m.id == id);
    if (index != -1) {
      final member = familyMembers[index];
      member.isSelected = !member.isSelected;
      familyMembers[index] = member; // triggers update
    }
  }
}
