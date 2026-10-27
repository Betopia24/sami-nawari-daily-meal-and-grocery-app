class NotificationResponseModel {
  final int? statusCode;
  final bool? success;
  final String? message;
  final List<NotificationItemModel> data;

  NotificationResponseModel({
    this.statusCode,
    this.success,
    this.message,
    required this.data,
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    List<NotificationItemModel> items = [];
    final list = json['data'];
    if (list is List) {
      items = list
          .whereType<Map<String, dynamic>>()
          .map((e) => NotificationItemModel.fromJson(e))
          .toList();
    }

    return NotificationResponseModel(
      statusCode: json['statusCode'] is int
          ? json['statusCode']
          : int.tryParse(json['statusCode']?.toString() ?? ''),
      success: json['success'] is bool
          ? json['success']
          : (json['success']?.toString().toLowerCase() == 'true'),
      message: json['message']?.toString(),
      data: items,
    );
  }
}

class NotificationItemModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type;
  bool isRead;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NotificationItemModel({
    this.id = '',
    this.userId = '',
    this.title = '',
    this.message = '',
    this.type = '',
    this.isRead = false,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) {
    return NotificationItemModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      isRead: json['isRead'] is bool
          ? json['isRead']
          : (json['isRead']?.toString().toLowerCase() == 'true'),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'type': type,
      'isRead': isRead,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  NotificationItemModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? message,
    String? type,
    bool? isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationItemModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Formats relative time (e.g. 5 min ago, 1h ago, Yesterday)
  String get timeAgo {
    if (createdAt == null) return '';
    final now = DateTime.now();
    final itemTime = createdAt!.isUtc ? createdAt!.toLocal() : createdAt!;
    final difference = now.difference(itemTime);

    if (difference.isNegative || difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${itemTime.day}/${itemTime.month}/${itemTime.year}';
    }
  }

  /// Maps notification type to a representative emoji
  String get displayEmoji {
    final upper = type.toUpperCase();
    if (upper.contains('ORDER')) return '🍕';
    if (upper.contains('RECIPE')) return '📖';
    if (upper.contains('GROCERY')) return '🛒';
    if (upper.contains('FAMILY')) return '👨‍👩‍👦';
    if (upper.contains('MARKETPLACE')) return '🏪';
    if (upper.contains('MEAL')) return '🍳';
    return '🔔';
  }
}
