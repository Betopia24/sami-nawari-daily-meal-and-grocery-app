import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class Ingredient {
  String name;
  String quantity;
  String unit;

  Ingredient({this.name = '', this.quantity = '1', this.unit = 'Piece (pcs)'});
}

class AddfooddetailsController extends GetxController {
  final preparationTimeController = TextEditingController(text: '25 mins');
  final preparationTime = '25 mins'.obs;
  
  final ingredients = <Ingredient>[Ingredient()].obs;
  
  final cookingSteps = <String>[''].obs;
  
  final isPickup = true.obs;
  final isDelivery = true.obs;
  final deliveryFee = '\$ 2.50'.obs;
  
  final deliveryFees = ['\$ 1.50', '\$ 2.00', '\$ 2.50', '\$ 5.00', '\$ 10.00'];

  Map<String, dynamic> stepOneData = {};

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Map) {
      stepOneData = Map<String, dynamic>.from(Get.arguments as Map);
    }
  }

  @override
  void onClose() {
    preparationTimeController.dispose();
    super.onClose();
  }

  void addIngredient() {
    ingredients.add(Ingredient());
  }

  void removeIngredient(int index) {
    if (ingredients.length > 1) {
      ingredients.removeAt(index);
    }
  }
  
  void updateIngredientName(int index, String value) {
    ingredients[index].name = value;
  }
  
  void updateIngredientQuantity(int index, String value) {
    ingredients[index].quantity = value;
  }
  
  void updateIngredientUnit(int index, String value) {
    ingredients[index].unit = value;
    ingredients.refresh();
  }

  void addStep() {
    cookingSteps.add('');
  }

  void removeStep(int index) {
    if (cookingSteps.length > 1) {
      cookingSteps.removeAt(index);
    }
  }

  void updateStep(int index, String value) {
    cookingSteps[index] = value;
  }

  void togglePickup() {
    isPickup.value = !isPickup.value;
  }

  void toggleDelivery() {
    isDelivery.value = !isDelivery.value;
  }

  void validateAndContinue() {
    final prepTime = preparationTimeController.text.trim();
    if (prepTime.isEmpty) {
      Get.snackbar(
        'Required Field',
        'Please enter preparation time (e.g. 25 mins)',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    final validIngredients = ingredients.where((i) => i.name.trim().isNotEmpty).toList();
    if (validIngredients.isEmpty) {
      Get.snackbar(
        'Required Field',
        'Please add at least one ingredient with a name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    if (!isPickup.value && !isDelivery.value) {
      Get.snackbar(
        'Required Field',
        'Please select at least one option: Pickup or Delivery',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    final parsedDeliveryFee = isDelivery.value
        ? (double.tryParse(deliveryFee.value.replaceAll(RegExp(r'[^\d.]'), '')) ?? 2.0)
        : 0.0;

    final combinedData = {
      ...stepOneData,
      'preparationTime': prepTime,
      'ingredients': validIngredients
          .map((i) => {
                'name': i.name.trim(),
                'quantity': num.tryParse(i.quantity.trim()) ?? 1,
                'unit': i.unit.trim(),
              })
          .toList(),
      'cookingSteps': cookingSteps
          .where((s) => s.trim().isNotEmpty)
          .toList(),
      'pickupAvailable': isPickup.value,
      'deliveryAvailable': isDelivery.value,
      'deliveryFee': parsedDeliveryFee,
    };

    Get.toNamed(Routes.previewfood, arguments: combinedData);
  }
}
