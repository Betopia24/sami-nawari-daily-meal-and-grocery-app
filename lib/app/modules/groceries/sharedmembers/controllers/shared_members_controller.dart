import 'package:get/get.dart';

class Member {
  final String id;
  final String name;
  final String avatarPath;
  String accessLevel;

  Member({
    required this.id,
    required this.name,
    required this.avatarPath,
    required this.accessLevel,
  });

  String get permissionDescription {
    if (accessLevel == 'Can Edit') {
      return 'Can add, edit and delete items';
    } else {
      return 'Can only view items';
    }
  }
}

class SharedMembersController extends GetxController {
  final members = <Member>[
    Member(id: '1', name: 'James', avatarPath: 'assets/images/user2.png', accessLevel: 'Can Edit'),
    Member(id: '2', name: 'Amara', avatarPath: 'assets/images/user1.png', accessLevel: 'View Only'),
    Member(id: '3', name: 'James', avatarPath: 'assets/images/user2.png', accessLevel: 'Can Edit'),
    Member(id: '4', name: 'Amara', avatarPath: 'assets/images/user1.png', accessLevel: 'View Only'),
  ].obs;

  void updateAccessLevel(String memberId, String newLevel) {
    var index = members.indexWhere((m) => m.id == memberId);
    if (index != -1) {
      members[index].accessLevel = newLevel;
      members.refresh();
    }
  }
}
