import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class AddnewfoodController extends GetxController {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  final selectedImages = <File>[].obs;
  final selectedCategory = Rxn<String>();

  final categories = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snacks',
  ];

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.onClose();
  }

  void updateImages(List<File> images) {
    selectedImages.value = images;
  }

  void validateAndContinue() {
    final name = nameController.text.trim();
    final description = descriptionController.text.trim();
    final priceText = priceController.text.trim().replaceAll(RegExp(r'[^\d.]'), '');
    final price = double.tryParse(priceText);
    final category = selectedCategory.value;

    if (name.isEmpty) {
      Get.snackbar(
        'Required Field',
        'Please enter food name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    if (description.isEmpty) {
      Get.snackbar(
        'Required Field',
        'Please enter food description',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    if (description.length < 10) {
      Get.snackbar(
        'Invalid Description',
        'Description must be at least 10 characters long',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    if (selectedImages.isEmpty) {
      Get.snackbar(
        'Required Field',
        'Please upload at least one food image',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    if (category == null || category.isEmpty) {
      Get.snackbar(
        'Required Field',
        'Please select a category',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    if (price == null || price <= 0) {
      Get.snackbar(
        'Invalid Price',
        'Please enter a valid price (e.g. 11.99)',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    Get.toNamed(Routes.addfooddetails, arguments: {
      'name': name,
      'description': description,
      'images': selectedImages.toList(),
      'category': category,
      'price': price,
    });
  }
}
