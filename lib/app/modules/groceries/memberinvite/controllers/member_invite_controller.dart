import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/groceries_controller.dart';

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

  FamilyMember copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarPath,
    bool? isSelected,
  }) {
    return FamilyMember(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarPath: avatarPath ?? this.avatarPath,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class MemberInviteController extends GetxController {
  final searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  final familyMembers = <FamilyMember>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadExistingFamilyMembers();
  }

  void _loadExistingFamilyMembers() {
    try {
      if (Get.isRegistered<GroceriesController>()) {
        final gc = Get.find<GroceriesController>();
        final seen = <String>{};
        final realMembers = <FamilyMember>[];

        for (final list in gc.groceryLists) {
          for (final m in list.members) {
            final key = m.name.trim().toLowerCase();
            if (key.isNotEmpty && !seen.contains(key)) {
              seen.add(key);
              realMembers.add(
                FamilyMember(
                  id: m.id.isNotEmpty ? m.id : m.userId,
                  name: m.name,
                  email: m.email,
                  avatarPath: m.profilePicture ?? '',
                  isSelected: false,
                ),
              );
            }
          }
        }
        familyMembers.assignAll(realMembers);
      }
    } catch (e) {
      debugPrint('Error loading existing members: $e');
    }
  }


  String get activeGroceryListId {
    if (Get.arguments is Map && Get.arguments['listId'] != null) {
      return Get.arguments['listId'].toString();
    }
    if (Get.isRegistered<GroceriesController>()) {
      return Get.find<GroceriesController>().activeGroceryListId.value;
    }
    return '';
  }

  List<FamilyMember> get filteredMembers {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return familyMembers;
    return familyMembers.where((m) {
      return m.name.toLowerCase().contains(query) ||
          m.email.toLowerCase().contains(query);
    }).toList();
  }

  void toggleSelection(String id) {
    final index = familyMembers.indexWhere((m) => m.id == id);
    if (index != -1) {
      final member = familyMembers[index];
      member.isSelected = !member.isSelected;
      familyMembers[index] = member; // triggers update
      familyMembers.refresh();
    }
  }

  bool addCustomEmail(String email, {String? name}) {
    final trimmed = email.trim();
    if (trimmed.isEmpty || !GetUtils.isEmail(trimmed)) {
      Get.snackbar(
        'Invalid Email',
        'Please enter a valid email address.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    }

    final existingIndex = familyMembers.indexWhere(
      (m) => m.email.toLowerCase() == trimmed.toLowerCase(),
    );
    if (existingIndex != -1) {
      familyMembers[existingIndex].isSelected = true;
      familyMembers.refresh();
      return true;
    }

    final memberName = name != null && name.trim().isNotEmpty
        ? name.trim()
        : trimmed.split('@').first;

    familyMembers.insert(
      0,
      FamilyMember(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: memberName,
        email: trimmed,
        avatarPath: '',
        isSelected: true,
      ),
    );
    return true;
  }

  List<FamilyMember> get selectedMembers =>
      familyMembers.where((m) => m.isSelected).toList();

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}

