import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../../core/constants/app_config.dart';

class AuthRepository {
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(Duration(milliseconds: AppConfig.connectTimeout));

      print('LOGIN STATUS: ${response.statusCode}');
      print('LOGIN BODY: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Handle kedua kemungkinan format response
        if (data['user'] != null) {
          return UserModel.fromJson(data['user']);
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

  Future<UserModel> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name, 
          'email': email, 
          'password': password,
          'password_confirmation': password
        }),
      ).timeout(Duration(milliseconds: AppConfig.connectTimeout));

      print('REGISTER STATUS: ${response.statusCode}');
      print('REGISTER BODY: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Handle kedua kemungkinan format response
        if (data['user'] != null) {
          return UserModel.fromJson(data['user']);
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

  // Method untuk test koneksi
  Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/sanctum/csrf-cookie'),
      ).timeout(Duration(seconds: 5));
      return response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }
}