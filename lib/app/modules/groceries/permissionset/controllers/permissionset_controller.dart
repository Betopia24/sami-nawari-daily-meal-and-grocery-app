import 'package:get/get.dart';

class PermissionMember {
  final String id;
  final String name;
  final String avatarPath;
  String accessLevel;

  PermissionMember({
    required this.id,
    required this.name,
    required this.avatarPath,
    this.accessLevel = 'Can Edit',
  });

  String get permissionDescription {
    if (accessLevel == 'Can Edit') {
      return 'Can add, edit and delete items';
    } else {
      return 'Can only view items';
    }
  }
}

class PermissionSetController extends GetxController {
  final members = <PermissionMember>[
    PermissionMember(
      id: '1',
      name: 'James',
      avatarPath: '',
      accessLevel: 'Can Edit',
    ),
    PermissionMember(
      id: '2',
      name: 'Amara',
      avatarPath: '',
      accessLevel: 'View Only',
    ),
  ].obs;

  final isSent = false.obs;

  void sendInvitations() {
    isSent.value = true;
  }

  void updateAccessLevel(String id, String newLevel) {
    final index = members.indexWhere((m) => m.id == id);
    if (index != -1) {
      final member = members[index];
      member.accessLevel = newLevel;
      members[index] = member; // triggers update
    }
  }
}
