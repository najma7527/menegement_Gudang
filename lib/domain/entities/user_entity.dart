class UserEntity {
  final int? id;
  final String name;
  final String email;
  final String? password;

  UserEntity({
    this.id,
    required this.name,
    required this.email,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }
}