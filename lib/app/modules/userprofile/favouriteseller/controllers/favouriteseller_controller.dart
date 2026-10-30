import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';
import '../../../../routes/app_routes.dart';
import '../../../explore/exploreboard/controllers/exploreboard_controller.dart';

class SellerModel {
  final String id;
  final String sellerId;
  final String imagePath;
  final bool isOpen;
  final String title;
  final String ownerName;
  final double rating;
  final int reviewCount;
  final double distance;
  final List<String>? tags;
  final bool hasPickup;
  final bool hasDelivery;
  final String description;
  final String address;

  SellerModel({
    required this.id,
    required this.sellerId,
    required this.imagePath,
    this.isOpen = true,
    required this.title,
    required this.ownerName,
    required this.rating,
    required this.reviewCount,
    required this.distance,
    this.tags,
    this.hasPickup = false,
    this.hasDelivery = false,
    required this.description,
    this.address = '',
  });

  Map<String, dynamic> toRestaurantMap() {
    return {
      'id': id,
      'sellerId': sellerId,
      'name': title,
      'owner': ownerName,
      'rating': rating,
      'reviews': reviewCount,
      'distance': '${distance.toStringAsFixed(1)} km',
      'time': tags != null && tags!.isNotEmpty ? tags!.first : '25 min',
      'deliveryFee': tags != null && tags!.length > 1 ? tags!.last : 'Delivery \$2.50',
      'isOpen': isOpen,
      'hasPickup': hasPickup,
      'hasDelivery': hasDelivery,
      'description': description,
      'image': imagePath,
      'address': address,
    };
  }
}

class FavouritesellerController extends GetxController {
  final favoriteSellers = <SellerModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFavoriteSellers();
  }

  /// Fetches saved favorite sellers from /bookmarks/sellers
  Future<void> fetchFavoriteSellers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      double lat = 23.7509;
      double lng = 90.3843;

      // Try reading location silently if permission granted
      try {
        final permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          final position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.medium,
              timeLimit: Duration(seconds: 4),
            ),
          );
          lat = position.latitude;
          lng = position.longitude;
        }
      } catch (_) {
        // Fallback to default coordinates (23.7509, 90.3843)
      }

      final queryParams = {
        'latitude': lat.toString(),
        'longitude': lng.toString(),
      };

      final response = await NetworkCaller.getRequest(
        Urls.getSellerPrifile,
        queryParameters: queryParams,
      );

      if (response.isSuccess && response.responseData != null) {
        final parsedList = _parseSellers(response.responseData);
        favoriteSellers.assignAll(parsedList);

        // Sync with ExploreboardController if registered
        if (Get.isRegistered<ExploreboardController>()) {
          final exploreCtrl = Get.find<ExploreboardController>();
          for (final s in parsedList) {
            exploreCtrl.bookmarkedSellerIds.add(s.sellerId);
          }
        }
      } else {
        errorMessage.value = response.errorMessage.isNotEmpty
            ? response.errorMessage
            : 'Failed to load favorite sellers';
      }
    } catch (e) {
      debugPrint('Error fetching favorite sellers: $e');
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Removes seller from favorites via POST /bookmarks/sellers/toggle
  Future<void> toggleFavoriteSeller(int index) async {
    if (index < 0 || index >= favoriteSellers.length) return;
    final seller = favoriteSellers[index];

    // Optimistic UI update
    favoriteSellers.removeAt(index);

    if (Get.isRegistered<ExploreboardController>()) {
      Get.find<ExploreboardController>().bookmarkedSellerIds.remove(seller.sellerId);
    }

    try {
      final response = await NetworkCaller.postRequest(
        Urls.sellerProfileFavourite,
        body: {'sellerId': seller.sellerId},
      );

      if (response.isSuccess) {
        Get.closeCurrentSnackbar();
        Get.snackbar(
          'Removed',
          '${seller.title} removed from favorite sellers',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
        );
      } else {
        // Rollback on failure
        favoriteSellers.insert(index, seller);
        if (Get.isRegistered<ExploreboardController>()) {
          Get.find<ExploreboardController>().bookmarkedSellerIds.add(seller.sellerId);
        }

        Get.closeCurrentSnackbar();
        Get.snackbar(
          'Error',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Could not remove favorite seller',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      favoriteSellers.insert(index, seller);
      if (Get.isRegistered<ExploreboardController>()) {
        Get.find<ExploreboardController>().bookmarkedSellerIds.add(seller.sellerId);
      }
      debugPrint('Error toggling favorite seller: $e');
    }
  }

  /// Navigate to view menu for the selected seller
  void viewSellerMenu(SellerModel seller) {
    Get.toNamed(Routes.viewmenu, arguments: seller.toRestaurantMap());
  }

  List<SellerModel> _parseSellers(dynamic rawResponse) {
    try {
      dynamic rawData;
      if (rawResponse is Map) {
        rawData = rawResponse['data'];
        if (rawData is Map && rawData['data'] is List) {
          rawData = rawData['data'];
        } else if (rawData is Map && rawData['items'] is List) {
          rawData = rawData['items'];
        } else if (rawData is Map && rawData['sellers'] is List) {
          rawData = rawData['sellers'];
        }
      } else if (rawResponse is List) {
        rawData = rawResponse;
      }

      if (rawData is List) {
        final List<SellerModel> list = [];
        for (int i = 0; i < rawData.length; i++) {
          final raw = rawData[i];
          if (raw is! Map) continue;
          final item = Map<String, dynamic>.from(raw);

          // Support nested seller object or flat seller profile
          Map<String, dynamic> sellerData = item;
          if (item['seller'] is Map) {
            sellerData = Map<String, dynamic>.from(item['seller']);
          } else if (item['sellerProfile'] is Map) {
            sellerData = Map<String, dynamic>.from(item['sellerProfile']);
          }

          final String id = item['id']?.toString() ??
              sellerData['id']?.toString() ??
              sellerData['_id']?.toString() ??
              '$i';

          final String sellerId = item['sellerId']?.toString() ??
              sellerData['id']?.toString() ??
              sellerData['sellerId']?.toString() ??
              sellerData['_id']?.toString() ??
              sellerData['userId']?.toString() ??
              id;

          // Title / Business Name
          final String title = sellerData['businessName']?.toString() ??
              sellerData['name']?.toString() ??
              item['businessName']?.toString() ??
              item['name']?.toString() ??
              'Kitchen';

          // Owner Name
          String ownerName = 'Home Cook';
          if (sellerData['user'] is Map) {
            ownerName = sellerData['user']['name']?.toString() ?? 'Home Cook';
          } else if (sellerData['ownerName'] != null) {
            ownerName = sellerData['ownerName'].toString();
          } else if (item['user'] is Map) {
            ownerName = item['user']['name']?.toString() ?? 'Home Cook';
          }

          // Image
          String imagePath = '';
          if (sellerData['kitchenImages'] is List &&
              (sellerData['kitchenImages'] as List).isNotEmpty) {
            imagePath = (sellerData['kitchenImages'] as List)[0]?.toString() ?? '';
          }
          if (imagePath.isEmpty && sellerData['image'] != null) {
            imagePath = sellerData['image'].toString();
          }
          if (imagePath.isEmpty && sellerData['profilePicture'] != null) {
            imagePath = sellerData['profilePicture'].toString();
          }
          if (imagePath.isEmpty && sellerData['user'] is Map) {
            imagePath = sellerData['user']['profilePicture']?.toString() ?? '';
          }
          if (imagePath.isEmpty) {
            imagePath = AppAssets.homeDinnerCardImage;
          }

          // Rating
          final double rating = (sellerData['averageRating'] as num?)?.toDouble() ??
              (sellerData['rating'] as num?)?.toDouble() ??
              (item['rating'] as num?)?.toDouble() ??
              4.8;

          // Review Count
          final int reviewCount = (sellerData['reviewCount'] as num?)?.toInt() ??
              (sellerData['reviews'] as num?)?.toInt() ??
              (item['reviewCount'] as num?)?.toInt() ??
              12;

          // Distance
          final num? distNum = (item['distanceKm'] as num?) ??
              (item['distance'] as num?) ??
              (sellerData['distanceKm'] as num?) ??
              (sellerData['distance'] as num?);
          final double distance = distNum?.toDouble() ?? 0.4;

          // Delivery fee & tags
          final num? fee = (sellerData['deliveryFee'] as num?) ?? (item['deliveryFee'] as num?);
          final String feeStr = fee != null
              ? 'Delivery \$${fee.toDouble().toStringAsFixed(2)}'
              : 'Delivery \$2.50';
          final List<String> tags = ['25 min', feeStr];

          // Pickup / Delivery
          final bool hasPickup = sellerData['pickupAvailable'] == true ||
              sellerData['hasPickup'] == true ||
              item['pickupAvailable'] == true;
          final bool hasDelivery = sellerData['deliveryAvailable'] == true ||
              sellerData['hasDelivery'] == true ||
              item['deliveryAvailable'] == true;

          // Open status
          final bool isOpen = sellerData['isOpen'] ?? item['isOpen'] ?? true;

          // Description
          final String description = sellerData['description']?.toString() ??
              item['description']?.toString() ??
              'Delicious homemade meals prepared fresh daily with authentic ingredients.';

          final String address = sellerData['address']?.toString() ??
              item['address']?.toString() ??
              '';

          list.add(
            SellerModel(
              id: id,
              sellerId: sellerId,
              imagePath: imagePath,
              isOpen: isOpen,
              title: title,
              ownerName: ownerName,
              rating: rating,
              reviewCount: reviewCount,
              distance: distance,
              tags: tags,
              hasPickup: hasPickup,
              hasDelivery: hasDelivery,
              description: description,
              address: address,
            ),
          );
        }
        return list;
      }
    } catch (e) {
      debugPrint('Error parsing favorite sellers list: $e');
    }
    return [];
  }
}
