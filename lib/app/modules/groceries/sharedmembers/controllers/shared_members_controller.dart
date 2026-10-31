import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daily_meal_and_grocery_app/core/utils/app_colors.dart';
import 'package:daily_meal_and_grocery_app/app/data/models/grocery_invitation_model.dart';
import 'package:daily_meal_and_grocery_app/app/data/network/network.dart';
import 'package:daily_meal_and_grocery_app/app/data/network/url.dart';
import '../../controllers/groceries_controller.dart';

class Member {
  final String id;
  final String memberId;
  final String name;
  final String avatarPath;
  String accessLevel;

  Member({
    required this.id,
    required this.memberId,
    required this.name,
    required this.avatarPath,
    required this.accessLevel,
  });

  String get permissionDescription {
    if (accessLevel == 'Owner') {
      return 'List owner with full control';
    } else if (accessLevel == 'Can Edit') {
      return 'Can add, edit and delete items';
    } else {
      return 'Can only view items';
    }
  }
}

class SharedMembersController extends GetxController {
  final members = <Member>[].obs;
  final myInvitations = <GroceryInvitationModel>[].obs;
  final isLoadingInvitations = false.obs;
  final isActionLoading = false.obs;

  String get activeGroceryListId {
    if (Get.isRegistered<GroceriesController>()) {
      return Get.find<GroceriesController>().activeGroceryListId.value;
    }
    return '';
  }

  @override
  void onInit() {
    super.onInit();
    loadMembers();
    fetchMyInvitations();
  }

  void loadMembers() {
    try {
      if (Get.isRegistered<GroceriesController>()) {
        final groceriesController = Get.find<GroceriesController>();
        final activeList = groceriesController.activeGroceryList;
        if (activeList != null && activeList.members.isNotEmpty) {
          members.assignAll(
            activeList.members.map((m) {
              final isOwner = m.role.toUpperCase() == 'OWNER';
              final isEditor = m.role.toUpperCase() == 'EDITOR';
              return Member(
                id: m.userId.isNotEmpty ? m.userId : m.id,
                memberId: m.id.isNotEmpty ? m.id : m.userId,
                name: m.name.isNotEmpty ? m.name : 'Member',
                avatarPath: m.profilePicture ?? '',
                accessLevel:
                    isOwner ? 'Owner' : (isEditor ? 'Can Edit' : 'View Only'),
              );
            }).toList(),
          );
        }
      }
    } catch (e) {
      debugPrint('Error loading shared members: $e');
    }
  }

  /// API #2: GET /grocery/invitations (Get My Invitations buyer)
  Future<void> fetchMyInvitations() async {
    try {
      isLoadingInvitations.value = true;
      final response = await NetworkCaller.getRequest(Urls.groceryInvitations);
      if (response.isSuccess && response.responseData != null) {
        final body = response.responseData;
        final rawData =
            body is Map && body['data'] is List ? body['data'] as List : [];
        final list = rawData
            .whereType<Map>()
            .map((e) =>
                GroceryInvitationModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        myInvitations.assignAll(list);
      }
    } catch (e) {
      debugPrint('Error fetching invitations: $e');
    } finally {
      isLoadingInvitations.value = false;
    }
  }

  /// API #3: PATCH /grocery/invitations/:invitationId/respond (Respond to Invitation)
  Future<void> respondToInvitation(
      GroceryInvitationModel invitation, bool accept) async {
    try {
      isActionLoading.value = true;
      final response = await NetworkCaller.patchRequest(
        Urls.groceryInvitationRespond(invitation.id),
        body: {
          'status': accept ? 'ACCEPTED' : 'DECLINED',
        },
      );

      if (response.isSuccess) {
        myInvitations.removeWhere((i) => i.id == invitation.id);
        Get.snackbar(
          accept ? 'Invitation Accepted' : 'Invitation Declined',
          accept
              ? 'You joined "${invitation.listName}" successfully!'
              : 'You declined the invitation to "${invitation.listName}".',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: accept ? AppColors.primary : Colors.grey.shade700,
          colorText: Colors.white,
        );

        if (accept && Get.isRegistered<GroceriesController>()) {
          await Get.find<GroceriesController>().fetchGroceryLists();
          loadMembers();
        }
      } else {
        Get.snackbar(
          'Action Failed',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Could not process invitation response.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Error responding to invitation: $e');
    } finally {
      isActionLoading.value = false;
    }
  }

  /// API #4: PATCH /grocery/:groceryListId/member/:memberId (Update Member Role)
  Future<void> updateAccessLevel(String memberId, String newLevel) async {
    final listId = activeGroceryListId;
    final index = members.indexWhere((m) => m.id == memberId || m.memberId == memberId);
    if (index == -1) return;

    final targetMember = members[index];
    final oldLevel = targetMember.accessLevel;

    // Optimistic update
    targetMember.accessLevel = newLevel;
    members[index] = targetMember;
    members.refresh();

    if (listId.isEmpty) return;

    try {
      final role = newLevel == 'Can Edit' ? 'EDITOR' : 'VIEWER';
      final response = await NetworkCaller.patchRequest(
        Urls.groceryMember(listId, targetMember.memberId),
        body: {'role': role},
      );

      if (response.isSuccess) {
        Get.snackbar(
          'Permission Updated',
          '${targetMember.name}\'s permission updated to $newLevel',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        _refreshParentList();
      } else {
        // Revert on failure
        targetMember.accessLevel = oldLevel;
        members[index] = targetMember;
        members.refresh();
        Get.snackbar(
          'Update Failed',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to update member permission.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Error updating member role: $e');
      targetMember.accessLevel = oldLevel;
      members[index] = targetMember;
      members.refresh();
    }
  }

  /// API #5: DELETE /grocery/:groceryListId/member/:memberId (Remove Member / Leave)
  Future<void> removeMember(Member member) async {
    final listId = activeGroceryListId;
    if (listId.isEmpty) return;

    try {
      final response = await NetworkCaller.deleteRequest(
        Urls.groceryMember(listId, member.memberId),
      );

      if (response.isSuccess) {
        members.removeWhere((m) => m.memberId == member.memberId);
        Get.snackbar(
          'Removed',
          '${member.name} has been removed from this grocery list.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
        );
        _refreshParentList();
      } else {
        Get.snackbar(
          'Error',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to remove member.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Error removing member: $e');
    }
  }


  void _refreshParentList() {
    if (Get.isRegistered<GroceriesController>() && activeGroceryListId.isNotEmpty) {
      Get.find<GroceriesController>().fetchGroceryListDetails(activeGroceryListId);
    }
  }
}


