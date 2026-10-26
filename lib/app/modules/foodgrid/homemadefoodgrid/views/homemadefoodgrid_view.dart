import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../routes/app_routes.dart';
import '../../../dashboard/widgets/homemade_food_card.dart';
import '../../widgets/food_grid_template.dart';
import '../controllers/homemadefoodgrid_controller.dart';

class HomemadefoodgridView extends GetView<HomemadefoodgridController> {
  const HomemadefoodgridView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return FoodGridTemplate(
        title: 'Homemade Food Near You',
        subtitle: 'Neighbor kitchens - pickup or seller delivery',
        isLoading: controller.isLoading.value,
        onRefresh: controller.fetchHomemadeFoods,
        itemCount: controller.foods.length,
        itemBuilder: (context, index) {
          final food = controller.foods[index];
          final distance = food.sellerAddress.isNotEmpty
              ? (food.sellerAddress.contains('km')
                  ? food.sellerAddress
                  : '1.2 km away')
              : '1.0 km away';

          return HomemadeFoodCard(
            title: food.name,
            subtitle: food.displaySeller,
            imagePath: food.firstImage.isNotEmpty
                ? food.firstImage
                : AppAssets.homeRecipeCardImage1,
            distance: distance,
            rating: food.rating.isNotEmpty ? food.rating : '4.8',
            price: '\$${food.price.toStringAsFixed(2)}',
            width: null,
            margin: EdgeInsets.zero,
            onAddTap: () => controller.addToCart(food),
            onViewDetailsTap: () => Get.toNamed(
              Routes.fooddetails,
              arguments: food.id,
            ),
          );
        },
      );
    });
  }
}
