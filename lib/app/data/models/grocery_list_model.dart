class GroceryListModel {
  final String id;
  final String name;
  final String description;
  final dynamic icon; // Can be IconData or String (emoji)
  final bool sharedWithFamily;
  final DateTime createdAt;

  GroceryListModel({
    required this.id,
    required this.name,
    this.description = '',
    required this.icon,
    this.sharedWithFamily = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
