import 'package:get/get.dart';

class ExploreboardController extends GetxController {
  final restaurants = [
    {
      'id': '1',
      'name': "Maria's Kitchen",
      'owner': 'Maria Santos',
      'rating': 4.9,
      'reviews': 412,
      'distance': '0.4 km',
      'time': '25 min',
      'deliveryFee': 'Delivery \$2.50',
      'isOpen': true,
      'hasPickup': true,
      'hasDelivery': true,
      'description':
          '"Classic Mezze Platter" — Hummus, baba ganoush, tabbouleh, olives, and fresh pita for 2. A taste of the Mediterranean coast.',
      'image': 'assets/images/homelunchcardimage.png', // Fallback image
    },
    {
      'id': '2',
      'name': "Chen's Dim Sum",
      'owner': 'Wei Chen',
      'rating': 4.7,
      'reviews': 1027,
      'distance': '0.8 km',
      'time': '30 min',
      'deliveryFee': 'Delivery \$3.50',
      'isOpen': true,
      'hasPickup': true,
      'hasDelivery': false,
      'description':
          '"Pork & Chive Dumplings (12pc)" — 12 hand-folded dumplings with pork and chive filling. Served with black vinegar dipping sauce.',
      'image': 'assets/images/homedinnercardimage.png', // Fallback image
    },
    {
      'id': '3',
      'name': "Priya's Spice House",
      'owner': 'Priya Sharma',
      'rating': 4.8,
      'reviews': 821,
      'distance': '1.2 km',
      'time': '40 min',
      'deliveryFee': 'Delivery \$3.00',
      'isOpen': false,
      'hasPickup': true,
      'hasDelivery': true,
      'description':
          '"Chicken Biryani" — Fragrant basmati rice layered with tender chicken, saffron, and crispy onions. A family recipe.',
      'image': 'assets/images/homereceipecardimage1.jpg', // Fallback image
    },
    {
      'id': '4',
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
      'description':
          '"Cacio e Pepe (Fresh Pasta)" — Hand-rolled tonnarelli pasta with Pecorino Romano, Parmesan, and black pepper. Simple perfection.',
      'image': 'assets/images/homereceipecardimage2.jpg', // Fallback image
    },
  ];

  @override
  void onInit() {
    super.onInit();
  }
}
