import 'package:flutter/material.dart';

class GroceryListModel {
  final String id;
  final String name;
  final String description;
  final dynamic icon; // Can be IconData or String (emoji)
  final bool sharedWithFamily;
  final int totalCount;
  final int completedCount;
  final int pendingCount;
  final int memberCount;
  final DateTime createdAt;

  GroceryListModel({
    required this.id,
    required this.name,
    this.description = '',
    required this.icon,
    this.sharedWithFamily = false,
    this.totalCount = 0,
    this.completedCount = 0,
    this.pendingCount = 0,
    this.memberCount = 1,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory GroceryListModel.fromJson(Map<String, dynamic> json) {
    final stats = json['stats'] is Map ? json['stats'] as Map : null;
    final membersList = json['members'] is List ? json['members'] as List : [];
    final nameStr = json['name']?.toString() ?? 'Grocery List';

    dynamic iconData = Icons.shopping_cart_outlined;
    final lowerName = nameStr.toLowerCase();
    if (lowerName.contains('bbq') || lowerName.contains('grill')) {
      iconData = Icons.outdoor_grill_outlined;
    } else if (lowerName.contains('monthly') || lowerName.contains('staple')) {
      iconData = Icons.inventory_2_outlined;
    } else if (lowerName.contains('meal') || lowerName.contains('dinner')) {
      iconData = Icons.ramen_dining_outlined;
    }

    return GroceryListModel(
      id: json['id']?.toString() ?? '',
      name: nameStr,
      description: json['description']?.toString() ?? '',
      icon: iconData,
      sharedWithFamily: membersList.length > 1,
      totalCount: stats?['total'] is num ? (stats!['total'] as num).toInt() : 0,
      completedCount: stats?['completed'] is num ? (stats!['completed'] as num).toInt() : 0,
      pendingCount: stats?['pending'] is num ? (stats!['pending'] as num).toInt() : 0,
      memberCount: membersList.isNotEmpty ? membersList.length : 1,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
