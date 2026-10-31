class GroceryInvitationModel {
  final String id;
  final String groceryListId;
  final String email;
  final String role;
  final String status;
  final String invitedById;
  final String listName;
  final String listDescription;
  final String inviterName;
  final String inviterEmail;
  final DateTime? createdAt;

  GroceryInvitationModel({
    required this.id,
    required this.groceryListId,
    required this.email,
    required this.role,
    required this.status,
    required this.invitedById,
    required this.listName,
    this.listDescription = '',
    required this.inviterName,
    required this.inviterEmail,
    this.createdAt,
  });

  factory GroceryInvitationModel.fromJson(Map<String, dynamic> json) {
    final groceryList =
        json['groceryList'] is Map ? json['groceryList'] as Map : null;
    final invitedBy =
        json['invitedBy'] is Map ? json['invitedBy'] as Map : null;

    return GroceryInvitationModel(
      id: json['id']?.toString() ?? '',
      groceryListId: json['groceryListId']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? 'EDITOR',
      status: json['status']?.toString() ?? 'PENDING',
      invitedById: json['invitedById']?.toString() ?? '',
      listName: groceryList?['name']?.toString() ?? 'Grocery List',
      listDescription: groceryList?['description']?.toString() ?? '',
      inviterName: invitedBy?['name']?.toString() ?? 'A member',
      inviterEmail: invitedBy?['email']?.toString() ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}
