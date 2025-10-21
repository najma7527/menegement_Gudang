import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../../core/constants/app_config.dart';

class AuthRepository {
  // 🔹 Login user
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('${AppConfig.baseUrl}/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(Duration(milliseconds: AppConfig.connectTimeout));

      print('LOGIN STATUS: ${response.statusCode}');
      print('LOGIN BODY: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // ✅ Pastikan token ikut dimasukkan ke user
        if (data['user'] != null && data['token'] != null) {
          final user = Map<String, dynamic>.from(data['user']);
          user['token'] = data['token'];
          return UserModel.fromJson(user);
        } else {
          return UserModel.fromJson(data);
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Login gagal');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Koneksi gagal. Periksa koneksi internet dan server.');
      }
      rethrow;
    }
  }

  // 🔹 Register user baru
  Future<UserModel> register(String name, String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('${AppConfig.baseUrl}/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
              'password_confirmation': password,
            }),
          )
          .timeout(Duration(milliseconds: AppConfig.connectTimeout));

      print('REGISTER STATUS: ${response.statusCode}');
      print('REGISTER BODY: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // ✅ Masukkan token ke user juga
        if (data['user'] != null && data['token'] != null) {
          final user = Map<String, dynamic>.from(data['user']);
          user['token'] = data['token'];
          return UserModel.fromJson(user);
        } else {
          return UserModel.fromJson(data);
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Registrasi gagal');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Koneksi gagal. Periksa koneksi internet dan server.');
      }
      rethrow;
    }
  }

  // 🔹 Logout user
  Future<void> logout(String token) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/logout'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('LOGOUT STATUS: ${response.statusCode}');
      if (response.statusCode != 200) {
        print('Logout gagal: ${response.body}');
      }
    } catch (e) {
      print('Error logout: $e');
    }
  }

  // 🔹 Test koneksi ke backend
  Future<bool> testConnection() async {
    try {
      final response = await http
          .get(Uri.parse('${AppConfig.baseUrl}/test-connection'))
          .timeout(const Duration(seconds: 5));
      print('TEST CONNECTION STATUS: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('Test connection error: $e');
      return false;
    }
  }
}
