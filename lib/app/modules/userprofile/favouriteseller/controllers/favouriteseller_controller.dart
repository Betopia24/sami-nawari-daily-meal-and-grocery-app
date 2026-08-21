import 'package:get/get.dart';
import '../../../../../core/utils/app_assets.dart';

class SellerModel {
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

  SellerModel({
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
  });
}

class FavouritesellerController extends GetxController {
  final favoriteSellers = <SellerModel>[
    SellerModel(
      imagePath: AppAssets.homeDinnerCardImage, // Using mock image
      title: "Maria's Kitchen",
      ownerName: "Maria Santos",
      rating: 4.9,
      reviewCount: 412,
      distance: 0.4,
      hasPickup: true,
      hasDelivery: true,
      description:
          '"Classic Mezze Platter" — Hummus, baba ganoush, tabbouleh, olives, and fresh pita for 2. A taste of the Mediterranean coast.',
    ),
    SellerModel(
      imagePath: AppAssets.homeLunchCardImage, // Using mock image
      title: "Luca's Pasta Club",
      ownerName: "Luca Buanchi",
      rating: 4.9,
      reviewCount: 338,
      distance: 1.5,
      tags: ['20 min', 'Delivery \$2.00'],
      hasPickup: true,
      hasDelivery: true,
      description:
          '"Cacio e Pepe (Fresh Pasta)" — Hand-rolled tonnarelli pasta with Pecorino Romano, Parmesan, and black pepper. Simple perfection.',
    ),
  ].obs;

  void unsaveSeller(int index) {
    favoriteSellers.removeAt(index);
  }
}
