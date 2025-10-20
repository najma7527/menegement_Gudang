class UserModel {
  final int id;
  final String name;
  final String email;
  final String? token;
  final String username; // Tambahkan field username
  final String password; // Tambahkan field password

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.username, // Tambahkan ke constructor
    required this.password, // Tambahkan ke constructor
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '', // Ambil dari JSON
      password: json['password'] ?? '', // Ambil dari JSON
      token: json['token'] ?? json['access_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "username": username,
      "password": password,
      "token": token,
    };
  }
}
