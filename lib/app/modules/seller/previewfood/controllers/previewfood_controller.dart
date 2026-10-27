import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import '../../../../data/network/local_storage.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';

class PreviewfoodController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final activeTab = 0.obs;

  final foodName = ''.obs;
  final description = ''.obs;
  final category = 'LUNCH'.obs;
  final subcategory = 'LIGHT'.obs;
  final price = 0.0.obs;
  final preparationTime = '25 mins'.obs;
  final images = <File>[].obs;
  final ingredients = <Map<String, dynamic>>[].obs;
  final cookingSteps = <String>[].obs;
  final pickupAvailable = true.obs;
  final deliveryAvailable = true.obs;
  final deliveryFee = 2.0.obs;
  final restaurantName = "Rafi's Kitchen".obs;

  final isSubmitting = false.obs;
  final isSubmitted = false.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      activeTab.value = tabController.index;
    });

    _loadArguments();
    _loadRestaurantName();
  }

  void _loadArguments() {
    final args = Get.arguments;
    if (args is Map) {
      if (args['name'] != null) foodName.value = args['name'].toString();
      if (args['description'] != null) description.value = args['description'].toString();
      if (args['category'] != null) category.value = args['category'].toString();
      if (args['price'] != null) {
        price.value = (args['price'] as num).toDouble();
      }
      if (args['preparationTime'] != null) {
        preparationTime.value = args['preparationTime'].toString();
      }
      if (args['images'] is List) {
        images.value = (args['images'] as List).whereType<File>().toList();
      }
      if (args['ingredients'] is List) {
        ingredients.value = (args['ingredients'] as List)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      }
      if (args['cookingSteps'] is List) {
        cookingSteps.value = (args['cookingSteps'] as List).map((e) => e.toString()).toList();
      }
      if (args['pickupAvailable'] is bool) {
        pickupAvailable.value = args['pickupAvailable'] as bool;
      }
      if (args['deliveryAvailable'] is bool) {
        deliveryAvailable.value = args['deliveryAvailable'] as bool;
      }
      if (args['deliveryFee'] is num) {
        deliveryFee.value = (args['deliveryFee'] as num).toDouble();
      }
    }
  }

  Future<void> _loadRestaurantName() async {
    try {
      final user = await LocalStorage.getUser();
      if (user != null && user['name'] != null && user['name'].toString().isNotEmpty) {
        restaurantName.value = "${user['name']}'s Kitchen";
      }
    } catch (_) {}
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> submit() async {
    if (isSubmitting.value) return;
    isSubmitting.value = true;

    try {
      final catUpper = category.value.toUpperCase();
      // Map valid subcategory allowed by backend
      String subcat = 'QUICK';
      if (catUpper == 'BREAKFAST') {
        subcat = 'QUICK';
      } else if (catUpper == 'LUNCH') {
        subcat = 'LIGHT';
      } else if (catUpper == 'DINNER') {
        subcat = 'FAMILY';
      } else if (catUpper == 'SNACKS') {
        subcat = 'SAVORY';
      }

      final foodPayload = {
        'name': foodName.value,
        'description': description.value,
        'category': catUpper,
        'subcategory': subcat,
        'price': price.value,
        'preparationTime': preparationTime.value,
        'pickupAvailable': pickupAvailable.value,
        'deliveryAvailable': deliveryAvailable.value,
        'deliveryFee': deliveryFee.value,
        'ingredients': ingredients.map((i) => {
              'name': i['name']?.toString() ?? '',
              'quantity': num.tryParse(i['quantity']?.toString() ?? '1') ?? 1,
              'unit': i['unit']?.toString() ?? 'g',
            }).toList(),
      };

      final formData = FormData();
      formData.fields.add(MapEntry('data', jsonEncode(foodPayload)));

      for (final img in images) {
        if (await img.exists()) {
          final fileName = img.path.split('/').last;
          formData.files.add(MapEntry(
            'files',
            await MultipartFile.fromFile(img.path, filename: fileName),
          ));
        }
      }

      final response = await NetworkCaller.multipartRequest(
        Urls.foods,
        formData: formData,
      );

      if (response.isSuccess &&
          (response.statusCode == 201 || response.statusCode == 200)) {
        isSubmitted.value = true;
        Get.snackbar(
          'Food Submitted',
          response.successMessage ?? 'Food item submitted for admin review successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1B5E37),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        final errorMsg = response.errorMessage.isNotEmpty
            ? response.errorMessage
            : 'Failed to submit food listing';
        Get.snackbar(
          'Submission Failed',
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Submission Error',
        'Could not submit food listing: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
