import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    'Desserts',
    'Beverages',
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
}
