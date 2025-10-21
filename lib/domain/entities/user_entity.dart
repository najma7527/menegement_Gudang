class UserEntity {
  final int? id;
  final String name;
  final String email;
  final String? password;
  final String? profile_photo;

  UserEntity({
    this.id,
    required this.name,
    required this.email,
    this.password,
    this.profile_photo,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'profile_photo': profile_photo,
    };
  }

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      profile_photo: json['profile_photo'],
    );
  }
}
