import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';
import '../../../userprofile/favouriteseller/controllers/favouriteseller_controller.dart';
import '../../widgets/explore_filter_bottom_sheet.dart';

class ExploreboardController extends GetxController {
  GoogleMapController? mapController;

  // Search controller and debounce
  final searchController = TextEditingController();
  Timer? _debounceTimer;

  // Initial center position (San Francisco default matching app address)
  final Rx<LatLng> initialPosition = const LatLng(37.7749, -122.4194).obs;
  final Rx<LatLng?> currentPosition = Rx<LatLng?>(null);
  final RxBool isGettingLocation = false.obs;
  final RxBool isMapReady = false.obs;
  final RxBool isLoadingSellers = true.obs;
  final RxSet<Marker> markers = <Marker>{}.obs;

  // Filter States
  final RxString selectedCuisine = ''.obs;
  final RxBool filterDeliveryAvailable = false.obs;
  final RxBool filterPickupAvailable = false.obs;
  final RxDouble filterRadius = 10.0.obs; // in km
  final RxBool filterByLocation = false.obs;

  int get activeFilterCount {
    int count = 0;
    if (selectedCuisine.value.isNotEmpty) count++;
    if (filterDeliveryAvailable.value) count++;
    if (filterPickupAvailable.value) count++;
    if (filterByLocation.value) count++;
    return count;
  }

  // Dynamic restaurants list from API
  final RxList<Map<String, dynamic>> restaurants = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> allRestaurants = <Map<String, dynamic>>[].obs;

  // Bookmarked seller IDs
  final RxSet<String> bookmarkedSellerIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // 1. Fetch live sellers from backend API (Urls.exploreSellers)
    fetchNearbySellers();

    // 2. Fetch bookmarked sellers to sync bookmark icons
    fetchBookmarkedSellerIds();

    // 3. Try to get current location silently
    _tryGetInitialLocationSilently();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    isMapReady.value = true;
  }

  /// Opens the Filter Bottom Sheet
  void openFilterBottomSheet() {
    Get.bottomSheet(
      const ExploreFilterBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  /// Applies filters selected in the bottom sheet and calls the API
  void applyFilters({
    required String cuisine,
    required bool delivery,
    required bool pickup,
    required double radius,
    required bool useLocation,
  }) {
    selectedCuisine.value = cuisine;
    filterDeliveryAvailable.value = delivery;
    filterPickupAvailable.value = pickup;
    filterRadius.value = radius;
    filterByLocation.value = useLocation;

    fetchNearbySellers();
  }

  /// Resets all filters and search query
  void resetFilters() {
    selectedCuisine.value = '';
    filterDeliveryAvailable.value = false;
    filterPickupAvailable.value = false;
    filterRadius.value = 10.0;
    filterByLocation.value = false;
    searchController.clear();

    fetchNearbySellers();
  }

  /// Debounced search listener calling the live backend API
  void onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 350), () {
      fetchNearbySellers();
    });
  }

  void clearSearch() {
    searchController.clear();
    fetchNearbySellers();
  }

  /// Connects to live API: GET /explore/sellers from Postman collection
  /// Supports: ?cuisine=ITALIAN&deliveryAvailable=true
  /// Supports: ?searchTerm=Alex&latitude=37.7749&longitude=-122.4194&radius=5000
  Future<void> fetchNearbySellers() async {
    try {
      isLoadingSellers.value = true;

      final Map<String, dynamic> queryParams = {
        'limit': 20,
      };

      final term = searchController.text.trim();
      if (term.isNotEmpty) {
        queryParams['searchTerm'] = term;
      }

      if (selectedCuisine.value.isNotEmpty) {
        queryParams['cuisine'] = selectedCuisine.value.toUpperCase();
      }

      if (filterDeliveryAvailable.value) {
        queryParams['deliveryAvailable'] = 'true';
      }

      if (filterPickupAvailable.value) {
        queryParams['pickupAvailable'] = 'true';
      }

      if (filterByLocation.value) {
        final pos = currentPosition.value ?? initialPosition.value;
        queryParams['latitude'] = pos.latitude.toString();
        queryParams['longitude'] = pos.longitude.toString();
        queryParams['radius'] = (filterRadius.value * 1000).toInt().toString();
      }

      debugPrint('➡️ [ExploreboardController] Calling GET ${Urls.exploreSellers} with params: $queryParams');

      final response = await NetworkCaller.getRequest(
        Urls.exploreSellers,
        queryParameters: queryParams,
      );

      if (response.isSuccess && response.responseData != null) {
        final body = response.responseData;
        dynamic rawData;
        if (body is Map) {
          rawData = body['data'];
          if (rawData is Map && rawData['data'] is List) {
            rawData = rawData['data'];
          } else if (rawData is Map && rawData['items'] is List) {
            rawData = rawData['items'];
          }
        } else if (body is List) {
          rawData = body;
        }

        if (rawData is List) {
          final List<Map<String, dynamic>> parsedList = [];
          for (int i = 0; i < rawData.length; i++) {
            final item = rawData[i];
            if (item is Map) {
              final Map<String, dynamic> s = Map<String, dynamic>.from(item);

              // Extract owner & picture safely
              String ownerName = 'Home Cook';
              String profilePic = '';
              if (s['user'] is Map) {
                ownerName = s['user']['name']?.toString() ?? 'Home Cook';
                profilePic = s['user']['profilePicture']?.toString() ?? '';
              } else if (s['ownerName'] != null) {
                ownerName = s['ownerName'].toString();
              }

              // Extract image
              String kitchenImg = profilePic;
              if (kitchenImg.isEmpty && s['kitchenImages'] is List && (s['kitchenImages'] as List).isNotEmpty) {
                kitchenImg = (s['kitchenImages'] as List)[0]?.toString() ?? '';
              }
              if (kitchenImg.isEmpty) {
                kitchenImg = _fallbackImages[i % _fallbackImages.length];
              }

              // Distance calculation/formatting
              String distStr = '0.4 km';
              if (s['distance'] != null) {
                final d = (s['distance'] as num).toDouble();
                distStr = d > 100 ? '${(d / 1000).toStringAsFixed(1)} km' : '${d.toStringAsFixed(1)} km';
              }

              // Location coords (if missing or 0, distribute around map center)
              final double latOffset = ((i % 2 == 0 ? 1 : -1) * (0.0035 * ((i ~/ 2) + 1)));
              final double lngOffset = ((i % 3 == 0 ? 1 : -1) * (0.0045 * ((i ~/ 3) + 1)));
              final double lat = (s['latitude'] as num?)?.toDouble() ??
                  (initialPosition.value.latitude + latOffset);
              final double lng = (s['longitude'] as num?)?.toDouble() ??
                  (initialPosition.value.longitude + lngOffset);

              final String sellerId = s['id']?.toString() ??
                  s['_id']?.toString() ??
                  s['sellerId']?.toString() ??
                  s['userId']?.toString() ??
                  '$i';

              parsedList.add({
                'id': sellerId,
                'sellerId': sellerId,
                'userId': s['userId']?.toString() ?? '',
                'name': s['businessName']?.toString() ?? 'Kitchen',
                'owner': ownerName,
                'rating': (s['averageRating'] as num?)?.toDouble() ?? 4.8,
                'reviews': (s['reviewCount'] as num?)?.toInt() ?? 12,
                'distance': distStr,
                'time': '25 min',
                'deliveryFee': s['deliveryFee'] != null
                    ? 'Delivery \$${(s['deliveryFee'] as num).toDouble().toStringAsFixed(2)}'
                    : 'Delivery \$2.50',
                'isOpen': s['isOpen'] ?? true,
                'hasPickup': s['pickupAvailable'] ?? true,
                'hasDelivery': s['deliveryAvailable'] ?? true,
                'latitude': lat,
                'longitude': lng,
                'description': s['description']?.toString() ??
                    'Delicious homemade meals prepared fresh daily with authentic ingredients.',
                'image': kitchenImg,
              });
            }
          }

          allRestaurants.assignAll(parsedList);
          restaurants.assignAll(parsedList);
          _initMarkers();
          return;
        }
      }

      // If empty or failed response
      restaurants.clear();
      _initMarkers();
    } catch (e) {
      debugPrint('Error fetching nearby sellers from API: $e');
      restaurants.clear();
      _initMarkers();
    } finally {
      isLoadingSellers.value = false;
    }
  }

  /// Fetches saved bookmark sellers to sync bookmark state
  Future<void> fetchBookmarkedSellerIds() async {
    try {
      final double lat = currentPosition.value?.latitude ?? 23.7509;
      final double lng = currentPosition.value?.longitude ?? 90.3843;

      final response = await NetworkCaller.getRequest(
        Urls.getSellerPrifile,
        queryParameters: {
          'latitude': lat.toString(),
          'longitude': lng.toString(),
        },
      );

      if (response.isSuccess && response.responseData != null) {
        dynamic rawData = response.responseData['data'];
        if (rawData is Map && rawData['data'] is List) {
          rawData = rawData['data'];
        } else if (rawData is Map && rawData['sellers'] is List) {
          rawData = rawData['sellers'];
        }

        if (rawData is List) {
          final Set<String> ids = {};
          for (final item in rawData) {
            if (item is Map) {
              final String sId = item['sellerId']?.toString() ??
                  item['seller']?['id']?.toString() ??
                  item['seller']?['_id']?.toString() ??
                  item['id']?.toString() ??
                  item['_id']?.toString() ??
                  '';
              if (sId.isNotEmpty) {
                ids.add(sId);
              }
            }
          }
          bookmarkedSellerIds.assignAll(ids);
        }
      }
    } catch (e) {
      debugPrint('Error fetching bookmarked sellers: $e');
    }
  }

  /// Toggles favorite status for a seller
  Future<void> toggleSellerBookmark(String sellerId, {String? sellerName}) async {
    if (sellerId.isEmpty) return;

    final bool isCurrentlyBookmarked = bookmarkedSellerIds.contains(sellerId);

    // Optimistic toggle
    if (isCurrentlyBookmarked) {
      bookmarkedSellerIds.remove(sellerId);
    } else {
      bookmarkedSellerIds.add(sellerId);
    }

    try {
      final response = await NetworkCaller.postRequest(
        Urls.sellerProfileFavourite,
        body: {'sellerId': sellerId},
      );

      if (response.isSuccess) {
        Get.closeCurrentSnackbar();
        Get.snackbar(
          isCurrentlyBookmarked ? 'Removed' : 'Saved',
          isCurrentlyBookmarked
              ? '${sellerName ?? "Seller"} removed from Favorite Sellers'
              : '${sellerName ?? "Seller"} added to Favorite Sellers',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
        );

        // Keep FavouritesellerController in sync if it is open/registered
        if (Get.isRegistered<FavouritesellerController>()) {
          Get.find<FavouritesellerController>().fetchFavoriteSellers();
        }
      } else {
        // Rollback on failure
        if (isCurrentlyBookmarked) {
          bookmarkedSellerIds.add(sellerId);
        } else {
          bookmarkedSellerIds.remove(sellerId);
        }

        Get.closeCurrentSnackbar();
        Get.snackbar(
          'Error',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Could not update favorite seller',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      // Rollback on exception
      if (isCurrentlyBookmarked) {
        bookmarkedSellerIds.add(sellerId);
      } else {
        bookmarkedSellerIds.remove(sellerId);
      }
      debugPrint('Error toggling seller bookmark: $e');
    }
  }

  void _initMarkers() {
    final Set<Marker> loadedMarkers = {};
    for (final restaurant in restaurants) {
      final double lat =
          (restaurant['latitude'] as num?)?.toDouble() ?? initialPosition.value.latitude;
      final double lng =
          (restaurant['longitude'] as num?)?.toDouble() ?? initialPosition.value.longitude;
      final String id = restaurant['id'].toString();
      final String name = restaurant['name'].toString();
      final String owner = restaurant['owner'].toString();
      final double rating =
          (restaurant['rating'] as num?)?.toDouble() ?? 4.8;
      final String time = restaurant['time'].toString();

      loadedMarkers.add(
        Marker(
          markerId: MarkerId(id),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: name,
            snippet: '$owner • $time • $rating ★',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        ),
      );
    }
    markers.assignAll(loadedMarkers);
  }

  Future<void> _tryGetInitialLocationSilently() async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      final LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        final Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 5),
          ),
        );
        currentPosition.value = LatLng(position.latitude, position.longitude);
      }
    } catch (_) {
      // Ignore silent location fetch failures
    }
  }

  /// Triggered by Current Location button on the map
  Future<void> getCurrentLocation() async {
    if (isGettingLocation.value) return;

    try {
      isGettingLocation.value = true;

      // 1. Check if location services are enabled
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar(
          'Location Disabled',
          'Please turn on your device location to view current location on map.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: AppColors.textPrimary,
          margin: const EdgeInsets.all(16),
        );
        return;
      }

      // 2. Check and request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'Permission Denied',
            'Location permission is required to find your current location.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: AppColors.textPrimary,
            margin: const EdgeInsets.all(16),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Permission Blocked',
          'Location permissions are permanently denied. Please enable them in device settings.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: AppColors.textPrimary,
          margin: const EdgeInsets.all(16),
        );
        return;
      }

      // 3. Retrieve accurate current location
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      final LatLng userLatLng = LatLng(position.latitude, position.longitude);
      currentPosition.value = userLatLng;

      // 4. Smoothly animate Google Map camera to the user's position
      if (mapController != null) {
        await mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: userLatLng,
              zoom: 15.0,
            ),
          ),
        );
      }

      // 5. Refresh sellers near user's new position
      fetchNearbySellers();
    } catch (e) {
      debugPrint('Error getting current location: $e');
      Get.snackbar(
        'Location Error',
        'Could not fetch current location. Please check your GPS signal and try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: AppColors.textPrimary,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isGettingLocation.value = false;
    }
  }

  void animateToRestaurant(double lat, double lng) {
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(lat, lng),
            zoom: 16.0,
          ),
        ),
      );
    }
  }

  static const List<String> _fallbackImages = [
    'assets/images/homelunchcardimage.png',
    'assets/images/homedinnercardimage.png',
    'assets/images/homereceipecardimage1.jpg',
    'assets/images/homereceipecardimage2.jpg',
  ];

  @override
  void onClose() {
    _debounceTimer?.cancel();
    searchController.dispose();
    mapController?.dispose();
    super.onClose();
  }
}
