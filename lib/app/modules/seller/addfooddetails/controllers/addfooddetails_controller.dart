import 'package:get/get.dart';

class Ingredient {
  String name;
  String quantity;
  String unit;

  Ingredient({this.name = '', this.quantity = '1', this.unit = 'Piece (pcs)'});
}

class AddfooddetailsController extends GetxController {
  final preparationTime = ''.obs;
  
  final ingredients = <Ingredient>[Ingredient()].obs;
  
  final cookingSteps = <String>[''].obs;
  
  final isPickup = false.obs;
  final isDelivery = false.obs;
  final deliveryFee = '\$ 2.50'.obs;
  
  final deliveryFees = ['\$ 2.50', '\$ 5.00', '\$ 10.00'];

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
}
