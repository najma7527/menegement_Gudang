class UserModel {
  final int? id;
  final String name;
  final String email;
  final String? token;
  final String? profilePhoto;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.token,
    this.profilePhoto,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['user']?['id'],
      name: json['name'] ?? json['user']?['name'] ?? '',
      email: json['email'] ?? json['user']?['email'] ?? '',
      token: json['token'] ?? json['access_token'],
      profilePhoto: json['profile_photo'] ?? json['profile_photo_url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
      'profile_photo': profilePhoto,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Method untuk membuat copy dengan field yang di-update
  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? token,
    String? profilePhoto,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
