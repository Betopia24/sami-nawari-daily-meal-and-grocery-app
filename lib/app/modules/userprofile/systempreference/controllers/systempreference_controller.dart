import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daily_meal_and_grocery_app/app/routes/app_routes.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/models/seller_profile_model.dart';
import '../../../../data/network/local_storage.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../seller/widgets/admin_approval_dialog.dart';

class SystempreferenceController extends GetxController {
  final user = Rxn<UserModel>();
  final sellerProfile = Rxn<SellerProfileData>();
  final isLoading = false.obs;
  final isLoadingSellerProfile = false.obs;

  final notificationsEnabled = true.obs;
  final isSellerMode = false.obs;
  final isRegisteredSeller = false.obs;
  final hasPendingSellerRequest = false.obs;
  final isSwitchingRole = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCachedUser();
    fetchUserProfile();
  }

  /// Load cached user profile immediately from local storage for instant display
  Future<void> _loadCachedUser() async {
    try {
      final cached = await LocalStorage.getUser();
      if (cached != null) {
        final parsedUser = UserModel.fromJson(cached);
        user.value = parsedUser;
        final isApproved =
            parsedUser.isSeller == true || (parsedUser.role?.toUpperCase() == 'SELLER');
        isRegisteredSeller.value = isApproved;
        if (isApproved) {
          hasPendingSellerRequest.value = false;
          await LocalStorage.setPendingSellerApproval(parsedUser.id, false);
          isSellerMode.value = (parsedUser.role?.toUpperCase() == 'SELLER');
          if (isSellerMode.value) {
            fetchSellerProfile();
          }
        } else {
          isSellerMode.value = false;
          hasPendingSellerRequest.value =
              await LocalStorage.isPendingSellerApproval(parsedUser.id);
        }
      }
    } catch (e) {
      debugPrint('Error loading cached user: $e');
    }
  }

  /// Fetch fresh user profile from backend via Urls.userMe ('/users/me')
  Future<void> fetchUserProfile() async {
    if (user.value == null) {
      isLoading.value = true;
    }
    try {
      final response = await NetworkCaller.getRequest(Urls.userMe);
      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData['data'];
        if (data is Map<String, dynamic>) {
          final fetchedUser = UserModel.fromJson(data);
          user.value = fetchedUser;
          await LocalStorage.saveUser(data);
          final isApproved =
              fetchedUser.isSeller == true || (fetchedUser.role?.toUpperCase() == 'SELLER');
          isRegisteredSeller.value = isApproved;
          if (isApproved) {
            hasPendingSellerRequest.value = false;
            await LocalStorage.setPendingSellerApproval(fetchedUser.id, false);
            isSellerMode.value = (fetchedUser.role?.toUpperCase() == 'SELLER');
            if (isSellerMode.value) {
              fetchSellerProfile();
            }
          } else {
            isSellerMode.value = false;
            // Query seller profile to check whether a request actually exists and is pending
            try {
              final sellerRes = await NetworkCaller.getRequest(Urls.sellerProfileMe);
              if (sellerRes.isSuccess &&
                  sellerRes.responseData != null &&
                  sellerRes.responseData['data'] != null) {
                final profileResponse =
                    SellerProfileResponseModel.fromJson(sellerRes.responseData);
                sellerProfile.value = profileResponse.data;
                final status = profileResponse.data?.status?.toUpperCase();
                final approved = status == 'APPROVED' || profileResponse.data?.isApproved == true;
                if (approved) {
                  isRegisteredSeller.value = true;
                  hasPendingSellerRequest.value = false;
                  await LocalStorage.setPendingSellerApproval(fetchedUser.id, false);
                  isSellerMode.value = (fetchedUser.role?.toUpperCase() == 'SELLER');
                  if (isSellerMode.value) {
                    fetchSellerProfile();
                  }
                } else {
                  hasPendingSellerRequest.value = true;
                  await LocalStorage.setPendingSellerApproval(fetchedUser.id, true);
                }
              } else {
                // 404 or profile not found: user has NOT submitted any seller request
                hasPendingSellerRequest.value = false;
                await LocalStorage.setPendingSellerApproval(fetchedUser.id, false);
              }
            } catch (_) {
              hasPendingSellerRequest.value =
                  await LocalStorage.isPendingSellerApproval(fetchedUser.id);
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching user profile in SystempreferenceController: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch seller profile via GET Urls.sellerProfileMe ('/seller/profile/me')
  /// Called whenever the user is in the "seller" role
  Future<void> fetchSellerProfile() async {
    isLoadingSellerProfile.value = true;
    try {
      final response = await NetworkCaller.getRequest(Urls.sellerProfileMe);
      if (response.isSuccess && response.responseData != null) {
        final profileResponse =
            SellerProfileResponseModel.fromJson(response.responseData);
        if (profileResponse.data != null) {
          sellerProfile.value = profileResponse.data;
          final status = profileResponse.data?.status?.toUpperCase();
          if (status == 'APPROVED') {
            isRegisteredSeller.value = true;
            hasPendingSellerRequest.value = false;
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching seller profile in SystempreferenceController: $e');
    } finally {
      isLoadingSellerProfile.value = false;
    }
  }

  /// Refreshes both user profile and seller profile (if in seller mode)
  Future<void> onRefresh() async {
    await fetchUserProfile();
    if (isSellerMode.value) {
      await fetchSellerProfile();
    }
  }

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
  }

  /// Switches between Buyer and Seller role via PATCH Urls.changeRole (/users/switch-role)
  Future<void> toggleSellerMode() async {
    if (isSwitchingRole.value) return;

    if (!isRegisteredSeller.value) {
      // User is not an approved seller
      isSellerMode.value = false;
      if (hasPendingSellerRequest.value) {
        showPendingApprovalDialog();
      } else {
        Get.toNamed(Routes.SELLER_STARTPAGE);
      }
      return;
    }

    isSwitchingRole.value = true;
    try {
      final response = await NetworkCaller.patchRequest(Urls.changeRole);

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData['data'];
        if (data is Map<String, dynamic>) {
          // 1. Update access token
          final newAccessToken = data['accessToken']?.toString();
          if (newAccessToken != null && newAccessToken.isNotEmpty) {
            await LocalStorage.saveAccessToken(newAccessToken);
          }

          // 2. Update refresh token if returned
          final newRefreshToken = data['refreshToken']?.toString();
          if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
            await LocalStorage.saveRefreshToken(newRefreshToken);
          }

          // 3. Update user role
          if (data['user'] is Map<String, dynamic>) {
            final userMap = data['user'] as Map<String, dynamic>;
            final updatedRole = userMap['role']?.toString().toUpperCase();
            if (updatedRole == 'SELLER') {
              isSellerMode.value = true;
            } else if (updatedRole == 'BUYER') {
              isSellerMode.value = false;
            } else {
              isSellerMode.value = !isSellerMode.value;
            }

            if (user.value != null) {
              user.value = user.value!.copyWith(
                role: updatedRole ?? (isSellerMode.value ? 'SELLER' : 'BUYER'),
                isSeller: userMap['isSeller'] is bool ? userMap['isSeller'] as bool : true,
              );
              await LocalStorage.saveUser(user.value!.toJson());
              await LocalStorage.saveRole(user.value!.role ?? '');
            }
          } else {
            isSellerMode.value = !isSellerMode.value;
          }
        } else {
          isSellerMode.value = !isSellerMode.value;
        }

        final modeName = isSellerMode.value ? 'Seller' : 'Buyer';
        if (isSellerMode.value) {
          fetchSellerProfile();
        }
        Get.snackbar(
          'Mode Changed',
          response.successMessage ?? 'Switched to $modeName mode successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: isSellerMode.value ? AppColors.primary : const Color(0xFF10B981),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        final errorMsg =
            response.errorMessage.isNotEmpty ? response.errorMessage : 'Failed to switch role';
        Get.snackbar(
          'Switch Failed',
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not switch role: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      isSwitchingRole.value = false;
    }
  }

  /// Shows popup informing user that admin approval is required to access seller mode
  void showPendingApprovalDialog() {
    AdminApprovalDialog.show(
      title: 'Pending Admin Approval',
      message:
          'Your seller registration request is currently under review. Please wait for an administrator to approve your application before accessing the seller dashboard.',
      onCheckStatus: () async {
        Get.back(); // close dialog
        isLoading.value = true;
        await fetchUserProfile();
        if (isRegisteredSeller.value) {
          Get.snackbar(
            'Application Approved!',
            'Congratulations! Your kitchen has been approved by the admin. Switching to Seller Mode.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.shade600,
            colorText: Colors.white,
          );
          isSellerMode.value = true;
        } else {
          Get.snackbar(
            'Still Pending Review',
            'Your application is still under review by the admin team. Please check back later.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFFD97706),
            colorText: Colors.white,
          );
        }
      },
    );
  }
}


