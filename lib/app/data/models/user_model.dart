class UserStats {
  final int recipesSaved;
  final int mealsCooked;
  final int groceryLists;

  const UserStats({
    this.recipesSaved = 0,
    this.mealsCooked = 0,
    this.groceryLists = 0,
  });

  factory UserStats.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const UserStats();
    return UserStats(
      recipesSaved: _toInt(json['recipesSaved']),
      mealsCooked: _toInt(json['mealsCooked']),
      groceryLists: _toInt(json['groceryLists']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipesSaved': recipesSaved,
      'mealsCooked': mealsCooked,
      'groceryLists': groceryLists,
    };
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? role;
  final String? status;
  final String? phone;
  final String? profilePicture;
  final String? username;
  final String? bio;
  final String? birthday;
  final String? gender;
  final String? address;
  final bool? isSeller;
  final List<String> dietaryPreferences;
  final List<String> allergies;
  final String? language;
  final String? country;
  final String? timeZone;
  final String? dateFormat;
  final String? timeFormat;
  final String? units;
  final String? currency;
  final String? fcmToken;
  final String? createdAt;
  final String? updatedAt;
  final UserStats? stats;
  final int recipesSaved;
  final int mealsCooked;
  final int groceryLists;

  const UserModel({
    this.id,
    this.name,
    this.email,
    this.role,
    this.status,
    this.phone,
    this.profilePicture,
    this.username,
    this.bio,
    this.birthday,
    this.gender,
    this.address,
    this.isSeller,
    this.dietaryPreferences = const [],
    this.allergies = const [],
    this.language,
    this.country,
    this.timeZone,
    this.dateFormat,
    this.timeFormat,
    this.units,
    this.currency,
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
    this.stats,
    this.recipesSaved = 0,
    this.mealsCooked = 0,
    this.groceryLists = 0,
  });

  /// Factory constructor to parse /users/me response
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? rawStats =
        json['stats'] is Map<String, dynamic> ? json['stats'] as Map<String, dynamic> : null;
    final int rSaved = rawStats != null
        ? UserStats._toInt(rawStats['recipesSaved'])
        : UserStats._toInt(json['recipesSaved']);
    final int mCooked = rawStats != null
        ? UserStats._toInt(rawStats['mealsCooked'])
        : UserStats._toInt(json['mealsCooked']);
    final int gLists = rawStats != null
        ? UserStats._toInt(rawStats['groceryLists'])
        : UserStats._toInt(json['groceryLists']);

    final parsedStats = UserStats(
      recipesSaved: rSaved,
      mealsCooked: mCooked,
      groceryLists: gLists,
    );

    return UserModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      role: json['role']?.toString(),
      status: json['status']?.toString(),
      phone: json['phone']?.toString(),
      profilePicture: json['profilePicture']?.toString(),
      username: json['username']?.toString(),
      bio: json['bio']?.toString(),
      birthday: json['birthday']?.toString(),
      gender: json['gender']?.toString(),
      address: json['address']?.toString(),
      isSeller: json['isSeller'] is bool
          ? json['isSeller'] as bool
          : (json['role']?.toString().toUpperCase() == 'SELLER'),
      dietaryPreferences: json['dietaryPreferences'] is List
          ? (json['dietaryPreferences'] as List)
              .map((e) => e.toString())
              .toList()
          : const [],
      allergies: json['allergies'] is List
          ? (json['allergies'] as List).map((e) => e.toString()).toList()
          : const [],
      language: json['language']?.toString(),
      country: json['country']?.toString(),
      timeZone: json['timeZone']?.toString(),
      dateFormat: json['dateFormat']?.toString(),
      timeFormat: json['timeFormat']?.toString(),
      units: json['units']?.toString(),
      currency: json['currency']?.toString(),
      fcmToken: json['fcmToken']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      stats: parsedStats,
      recipesSaved: rSaved,
      mealsCooked: mCooked,
      groceryLists: gLists,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'status': status,
      'phone': phone,
      'profilePicture': profilePicture,
      'username': username,
      'bio': bio,
      'birthday': birthday,
      'gender': gender,
      'address': address,
      'isSeller': isSeller,
      'dietaryPreferences': dietaryPreferences,
      'allergies': allergies,
      'language': language,
      'country': country,
      'timeZone': timeZone,
      'dateFormat': dateFormat,
      'timeFormat': timeFormat,
      'units': units,
      'currency': currency,
      'fcmToken': fcmToken,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'stats': stats?.toJson() ?? {
        'recipesSaved': recipesSaved,
        'mealsCooked': mealsCooked,
        'groceryLists': groceryLists,
      },
      'recipesSaved': recipesSaved,
      'mealsCooked': mealsCooked,
      'groceryLists': groceryLists,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? status,
    String? phone,
    String? profilePicture,
    String? username,
    String? bio,
    String? birthday,
    String? gender,
    String? address,
    bool? isSeller,
    List<String>? dietaryPreferences,
    List<String>? allergies,
    String? language,
    String? country,
    String? timeZone,
    String? dateFormat,
    String? timeFormat,
    String? units,
    String? currency,
    String? fcmToken,
    String? createdAt,
    String? updatedAt,
    UserStats? stats,
    int? recipesSaved,
    int? mealsCooked,
    int? groceryLists,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      status: status ?? this.status,
      phone: phone ?? this.phone,
      profilePicture: profilePicture ?? this.profilePicture,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      isSeller: isSeller ?? this.isSeller,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      allergies: allergies ?? this.allergies,
      language: language ?? this.language,
      country: country ?? this.country,
      timeZone: timeZone ?? this.timeZone,
      dateFormat: dateFormat ?? this.dateFormat,
      timeFormat: timeFormat ?? this.timeFormat,
      units: units ?? this.units,
      currency: currency ?? this.currency,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      stats: stats ?? this.stats,
      recipesSaved: recipesSaved ?? this.recipesSaved,
      mealsCooked: mealsCooked ?? this.mealsCooked,
      groceryLists: groceryLists ?? this.groceryLists,
    );
  }

  /// Convenience getters
  String get displayName {
    if (name != null && name!.trim().isNotEmpty) {
      return name!.trim();
    }
    if (username != null && username!.trim().isNotEmpty) {
      return username!.trim();
    }
    return 'User';
  }

  String get displayEmail => email ?? '';

  String get displayPhone => phone ?? '';

  String get displayRole {
    if (role != null && role!.trim().isNotEmpty) {
      final r = role!.trim();
      return r[0].toUpperCase() + r.substring(1).toLowerCase();
    }
    return (isSeller == true) ? 'Seller' : 'Buyer';
  }

  bool get hasProfilePicture =>
      profilePicture != null && profilePicture!.trim().isNotEmpty;
}
