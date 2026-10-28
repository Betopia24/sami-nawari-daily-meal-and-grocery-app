import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';

class ExploreboardController extends GetxController {
  GoogleMapController? mapController;

  // Search controller
  final searchController = TextEditingController();

  // Initial center position (San Francisco default matching app address)
  final Rx<LatLng> initialPosition = const LatLng(37.7749, -122.4194).obs;
  final Rx<LatLng?> currentPosition = Rx<LatLng?>(null);
  final RxBool isGettingLocation = false.obs;
  final RxBool isMapReady = false.obs;
  final RxBool isLoadingSellers = true.obs;
  final RxSet<Marker> markers = <Marker>{}.obs;

  // Dynamic restaurants list from API
  final RxList<Map<String, dynamic>> restaurants = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> allRestaurants = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // 1. Fetch live sellers from backend API (Urls.exploreSellers)
    fetchNearbySellers();

    // 2. Try to get current location silently
    _tryGetInitialLocationSilently();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    isMapReady.value = true;
  }

  /// Connects to live API: GET /explore/sellers from Postman collection
  Future<void> fetchNearbySellers() async {
    try {
      isLoadingSellers.value = true;
      restaurants.clear();
      allRestaurants.clear();

      final Map<String, dynamic> queryParams = {
        'limit': 20,
      };

      if (currentPosition.value != null) {
        queryParams['latitude'] = currentPosition.value!.latitude.toString();
        queryParams['longitude'] = currentPosition.value!.longitude.toString();
        queryParams['radius'] = '10000';
      }

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

        if (rawData is List && rawData.isNotEmpty) {
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

              // Location coords (if missing, distribute nicely around map center)
              final double latOffset = ((i % 2 == 0 ? 1 : -1) * (0.0025 * ((i ~/ 2) + 1)));
              final double lngOffset = ((i % 3 == 0 ? 1 : -1) * (0.0035 * ((i ~/ 3) + 1)));
              final double lat = (s['latitude'] as num?)?.toDouble() ??
                  (initialPosition.value.latitude + latOffset);
              final double lng = (s['longitude'] as num?)?.toDouble() ??
                  (initialPosition.value.longitude + lngOffset);

              parsedList.add({
                'id': s['id']?.toString() ?? s['userId']?.toString() ?? '$i',
                'sellerId': s['id']?.toString() ?? s['userId']?.toString() ?? '',
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

          if (parsedList.isNotEmpty) {
            allRestaurants.assignAll(parsedList);
            restaurants.assignAll(parsedList);
            _initMarkers();
            return;
          }
        }
      }

      if (restaurants.isEmpty) {
        _loadFallbackRestaurants();
        _initMarkers();
      }
    } catch (e) {
      debugPrint('Error fetching nearby sellers from API: $e');
      if (restaurants.isEmpty) {
        _loadFallbackRestaurants();
        _initMarkers();
      }
    } finally {
      isLoadingSellers.value = false;
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
          (restaurant['rating'] as num?)?.toDouble() ?? 4.5;
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

  void onSearchChanged(String query) {
    if (query.trim().isEmpty) {
      restaurants.assignAll(allRestaurants);
    } else {
      final lower = query.toLowerCase();
      restaurants.assignAll(
        allRestaurants.where((r) {
          final name = (r['name'] ?? '').toString().toLowerCase();
          final desc = (r['description'] ?? '').toString().toLowerCase();
          final owner = (r['owner'] ?? '').toString().toLowerCase();
          return name.contains(lower) || desc.contains(lower) || owner.contains(lower);
        }).toList(),
      );
    }
    _initMarkers();
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

  void _loadFallbackRestaurants() {
    final list = [
      {
        'id': '6a86bec0da330f33e60f935a',
        'sellerId': '6a7804181dc04f6bd575f7e0',
        'name': "Rafi's Kitchen Pro",
        'owner': 'Rafiul Islam',
        'rating': 4.9,
        'reviews': 412,
        'distance': '0.4 km',
        'time': '25 min',
        'deliveryFee': 'Delivery \$2.50',
        'isOpen': true,
        'hasPickup': true,
        'hasDelivery': true,
        'latitude': 37.7765,
        'longitude': -122.4170,
        'description':
            'Premium home-cooked Mediterranean and Italian meals prepared with love and organic ingredients.',
        'image': 'https://res.cloudinary.com/dgk8lgdzb/image/upload/v1787216596/uploads/dcmbp9qlrgl0rybjpnaw.webp',
      },
      {
        'id': '6a8d5923b0849aa545857175',
        'sellerId': '6a8d58bab0849aa545857173',
        'name': "Nayeem Kitchen",
        'owner': 'Seller Nayeem',
        'rating': 4.7,
        'reviews': 1027,
        'distance': '0.8 km',
        'time': '30 min',
        'deliveryFee': 'Delivery \$3.50',
        'isOpen': true,
        'hasPickup': true,
        'hasDelivery': false,
        'latitude': 37.7790,
        'longitude': -122.4230,
        'description':
            'Healthy homemade meals with fresh ingredients. Dumplings, pasta, and comfort foods.',
        'image': 'assets/images/homedinnercardimage.png',
      },
      {
        'id': '6a8e6fd99b955a97a74b15bd',
        'sellerId': '6a8e6df185d3f55f0f1a6783',
        'name': "Spice Garden Cafe",
        'owner': 'Priya Sharma',
        'rating': 4.8,
        'reviews': 821,
        'distance': '1.2 km',
        'time': '40 min',
        'deliveryFee': 'Delivery \$3.00',
        'isOpen': false,
        'hasPickup': true,
        'hasDelivery': true,
        'latitude': 37.7710,
        'longitude': -122.4140,
        'description':
            'Experience the authentic taste of home-cooked spices and delicious Chinese fusion.',
        'image': 'assets/images/homereceipecardimage1.jpg',
      },
      {
        'id': '4',
        'sellerId': '4',
        'name': "Luca's Pasta Club",
        'owner': 'Luca Bianchi',
        'rating': 4.9,
        'reviews': 640,
        'distance': '1.6 km',
        'time': '30 min',
        'deliveryFee': 'Delivery \$2.00',
        'isOpen': true,
        'hasPickup': true,
        'hasDelivery': true,
        'latitude': 37.7680,
        'longitude': -122.4260,
        'description':
            '"Cacio e Pepe (Fresh Pasta)" — Hand-rolled tonnarelli pasta with Pecorino Romano, Parmesan, and black pepper.',
        'image': 'assets/images/homereceipecardimage2.jpg',
      },
    ];
    allRestaurants.assignAll(list);
    restaurants.assignAll(list);
  }

  static const List<String> _fallbackImages = [
    'assets/images/homelunchcardimage.png',
    'assets/images/homedinnercardimage.png',
    'assets/images/homereceipecardimage1.jpg',
    'assets/images/homereceipecardimage2.jpg',
  ];

  @override
  void onClose() {
    searchController.dispose();
    mapController?.dispose();
    super.onClose();
  }
}
