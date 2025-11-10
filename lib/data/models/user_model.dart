class UserModel {
  final int? id;
  final String name;
  final String email;
  final String? profilePhoto;
  final String? token;
  final String? profilePhotoBase64;
  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.profilePhoto,
    this.token,
    this.profilePhotoBase64,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profilePhoto: json['profile_photo'],
      token: json['token'],
      profilePhotoBase64: json['profile_photo_base64'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_photo': profilePhoto,
      'token': token,
      'profile_photo_url': profilePhotoBase64,
    };
  }
}
