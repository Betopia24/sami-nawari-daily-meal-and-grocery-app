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
    // Dummy data matching the mockup
    final List<Map<String, String>> homemadeFoods = [
      {
        'title': 'Chicken Biryani Tiffin',
        'subtitle': "Amina's Home Kitchen",
        'imagePath': AppAssets.homeRecipeCardImage1,
        'distance': '0.8 km',
        'rating': '4.9 (214)',
        'price': '\$6.50',
      },
      {
        'title': 'Steamed Veg Dumplings',
        'subtitle': "Mei's Dumpling Table",
        'imagePath': AppAssets.homeRecipeCardImage2,
        'distance': '1.4 km',
        'rating': '4.7 (132)',
        'price': '\$4.00',
      },
      {
        'title': 'Lemon Lentil Soup & Bread',
        'subtitle': "Nur's Soup House",
        'imagePath': AppAssets.homeRecipeCardImage3,
        'distance': '2.1 km',
        'rating': '4.8 (96)',
        'price': '\$3.50',
      },
      {
        'title': 'Spanakopita',
        'subtitle': "Maria's Kitchen",
        'imagePath': AppAssets.homeRecipeCardImage1,
        'distance': '1.1 km',
        'rating': '4.5 (110)',
        'price': '\$4.50',
      },
      {
        'title': 'Lamb Kofta with Rice',
        'subtitle': "Chen's Dim Sum",
        'imagePath': AppAssets.homeRecipeCardImage2,
        'distance': '0.7 km',
        'rating': '4.9 (88)',
        'price': '\$7.00',
      },
    ];

    return FoodGridTemplate(
      title: 'Homemade Food Near You',
      subtitle: 'Neighbor kitchens - pickup or seller delivery',
      itemCount: homemadeFoods.length,
      itemBuilder: (context, index) {
        final food = homemadeFoods[index];
        return HomemadeFoodCard(
          title: food['title']!,
          subtitle: food['subtitle']!,
          imagePath: food['imagePath']!,
          distance: food['distance']!,
          rating: food['rating']!,
          price: food['price']!,
          width: null, // Let grid manage width
          margin: EdgeInsets.zero, // Remove right margin in grid
          onAddTap: () {},
          onViewDetailsTap: () => Get.toNamed(
            Routes.fooddetails,
            arguments: '6a8d6ca9e87759724844e5ec',
          ),
        );
      },
    );
  }
}
