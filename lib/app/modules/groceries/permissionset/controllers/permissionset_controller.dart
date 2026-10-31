import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daily_meal_and_grocery_app/core/utils/app_colors.dart';
import 'package:daily_meal_and_grocery_app/app/data/network/network.dart';
import 'package:daily_meal_and_grocery_app/app/data/network/url.dart';
import '../../controllers/groceries_controller.dart';
import '../../memberinvite/controllers/member_invite_controller.dart';

class PermissionMember {
  final String id;
  final String name;
  final String email;
  final String avatarPath;
  String accessLevel;

  PermissionMember({
    required this.id,
    required this.name,
    required this.email,
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
  final members = <PermissionMember>[].obs;
  final isSent = false.obs;
  final isSending = false.obs;

  String groceryListId = '';

  @override
  void onInit() {
    super.onInit();
    _loadArguments();
  }

  void _loadArguments() {
    final args = Get.arguments;
    if (args is Map) {
      groceryListId = args['listId']?.toString() ?? '';
      if (args['members'] is List) {
        final rawMembers = args['members'] as List;
        final parsed = rawMembers.map((m) {
          if (m is FamilyMember) {
            return PermissionMember(
              id: m.id,
              name: m.name,
              email: m.email,
              avatarPath: m.avatarPath,
              accessLevel: 'Can Edit',
            );
          } else if (m is PermissionMember) {
            return m;
          }
          return PermissionMember(
            id: m['id']?.toString() ?? '',
            name: m['name']?.toString() ?? '',
            email: m['email']?.toString() ?? '',
            avatarPath: m['avatarPath']?.toString() ?? '',
            accessLevel: m['accessLevel']?.toString() ?? 'Can Edit',
          );
        }).toList();
        members.assignAll(parsed);
      }
    }

    if (groceryListId.isEmpty && Get.isRegistered<GroceriesController>()) {
      groceryListId = Get.find<GroceriesController>().activeGroceryListId.value;
    }
  }

  Future<void> sendInvitations() async {
    if (groceryListId.isEmpty) {
      Get.snackbar(
        'Error',
        'No active grocery list found to invite members to.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (members.isEmpty) {
      Get.snackbar(
        'Notice',
        'No members selected to invite.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isSending.value = true;
      int successCount = 0;
      String? lastErrorMessage;

      for (final member in members) {
        final role = member.accessLevel == 'Can Edit' ? 'EDITOR' : 'VIEWER';
        final body = {
          'email': member.email,
          'role': role,
        };

        final response = await NetworkCaller.postRequest(
          Urls.groceryInvite(groceryListId),
          body: body,
        );

        if (response.isSuccess) {
          successCount++;
        } else {
          lastErrorMessage = response.errorMessage;
        }
      }

      if (successCount > 0) {
        isSent.value = true;
        // Refresh groceries controller so new member/invitation counts update
        if (Get.isRegistered<GroceriesController>()) {
          Get.find<GroceriesController>().fetchGroceryListDetails(groceryListId);
        }
      } else {
        Get.snackbar(
          'Invitation Failed',
          lastErrorMessage ?? 'Unable to send invitations. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Error sending invitations: $e');
      Get.snackbar(
        'Error',
        'Something went wrong while sending invitations.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isSending.value = false;
    }
  }

  void updateAccessLevel(String id, String newLevel) {
    final index = members.indexWhere((m) => m.id == id);
    if (index != -1) {
      final member = members[index];
      member.accessLevel = newLevel;
      members[index] = member; // triggers update
      members.refresh();
    }
  }
}

