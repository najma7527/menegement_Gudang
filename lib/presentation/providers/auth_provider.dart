import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';
import 'provider_manager.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  final String baseUrl = "http://127.0.0.1:8000";
  String get apiUrl => "$baseUrl/api";

  UserModel? get currentUser => _currentUser;
  UserModel? get user => _currentUser;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  String? _token;
  String? get token => _token;

  get html => null;

  // 🔹 RESET METHOD
  void reset() {
    _currentUser = null;
    _isLoading = false;
    _error = null;
    _isAuthenticated = false;
    _token = null;
    notifyListeners();
    print('🔄 AuthProvider di-reset');
  }

  Future<bool> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _authRepository.login(email, password);
      _token = _currentUser?.token;
      _isAuthenticated = true;

      if (_currentUser?.id != null) {
        ProviderManager.setUserIdForAllProviders(context, _currentUser!.id!);

        // Tunda load data sampai setelah build selesai
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ProviderManager.loadAllData(context);
        });
      }

      return true;
    } catch (e) {
      print("Login error: $e");
      _isAuthenticated = false;
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(
    String name,
    String email,
    String password,
    BuildContext context,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _authRepository.register(name, email, password);
      _token = _currentUser?.token;
      _isAuthenticated = true;

      if (_currentUser?.id != null) {
        ProviderManager.setUserIdForAllProviders(context, _currentUser!.id!);

        // Tunda load data sampai setelah build selesai
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ProviderManager.loadAllData(context);
        });
      }

      return true;
    } catch (e) {
      print("Register error: $e");
      _isAuthenticated = false;
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 UPDATE LOGOUT METHOD
  void logout(BuildContext context) {
    // Reset semua provider
    ProviderManager.resetAllProviders(context);

    reset();

    print('✅ Logout berhasil, semua provider di-reset');
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// ✅ Update data profil tanpa foto
  Future<bool> updateProfile(String name, String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/profile/update'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: {'name': name, 'email': email},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _currentUser = UserModel.fromJson(data['user']);
        return true;
      } else {
        print('Update gagal: ${response.body}');
        return false;
      }
    } catch (e) {
      print("Update profile error: $e");
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfileWithPhoto({
    required String name,
    required String email,
    dynamic imageFile,
  }) async {
    try {
      if (_token == null) {
        print("❌ Token tidak tersedia");
        return false;
      }

      final url = Uri.parse('$baseUrl/api/profile/update');
      final request = http.MultipartRequest('POST', url);

      request.fields['name'] = name;
      request.fields['email'] = email;

      request.headers['Authorization'] = 'Bearer $_token';
      request.headers['Accept'] = 'application/json';

      print("📤 Data ke server: name=$name, email=$email");

      if (imageFile != null) {
        if (kIsWeb) {
          final bytes = imageFile['bytes'] as Uint8List?;
          final fileName = imageFile['name'] as String?;
          if (bytes != null && fileName != null) {
            request.files.add(
              http.MultipartFile.fromBytes(
                'profile_photo',
                bytes,
                filename: fileName,
              ),
            );
            print("✅ File web ditambahkan: $fileName");
          }
        } else {
          final file = imageFile as File;
          if (await file.exists()) {
            request.files.add(
              await http.MultipartFile.fromPath('profile_photo', file.path),
            );
            print("✅ File mobile ditambahkan: ${file.path}");
          }
        }
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print("📥 Response status: ${response.statusCode}");
      print("📥 Response body: $responseBody");

      if (response.statusCode == 200) {
        print("✅ Upload success");
        await fetchUser();
        return true;
      } else if (response.statusCode == 422) {
        try {
          final errorData = json.decode(responseBody);
          print("❌ Validasi gagal: $errorData");
          if (errorData['errors'] != null) {
            final errors = errorData['errors'] as Map<String, dynamic>;
            errors.forEach((field, messages) {
              print("❌ $field: ${messages.join(', ')}");
            });
          }
        } catch (e) {
          print("❌ Gagal parsing error response: $e");
        }
        return false;
      } else if (response.statusCode == 401) {
        print("❌ Token tidak valid (401)");
        logout(navigatorKey.currentContext!);
        return false;
      } else {
        print("❌ Upload failed: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("❌ Error updateProfileWithPhoto: $e");
      return false;
    }
  }

  Future<void> fetchUser() async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/profile'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('📱 Data user diterima: ${data['user']}');

        // Periksa base64
        if (data['user']['profile_photo_base64'] != null) {
          print(
            '✅ Base64 diterima, panjang: ${data['user']['profile_photo_base64'].length}',
          );
        } else {
          print('❌ Base64 tidak diterima dalam response');
        }

        _currentUser = UserModel.fromJson(data['user']);
        notifyListeners();
      } else {
        print('❌ Gagal mengambil data user: ${response.statusCode}');
        print('❌ Response body: ${response.body}');
      }
    } catch (e) {
      print('❌ Error fetchUser: $e');
    }
  }

  String? getFullProfilePhotoUrl() {
    // Prioritaskan base64 jika ada
    if (_currentUser?.profilePhotoBase64 != null &&
        _currentUser!.profilePhotoBase64!.isNotEmpty) {
      print('✅ Menggunakan foto base64');
      return _currentUser!.profilePhotoBase64;
    }

    // Jika tidak ada base64, coba bangun URL
    if (_currentUser?.profilePhoto == null ||
        _currentUser!.profilePhoto!.isEmpty) {
      print('❌ Tidak ada foto profil');
      return null;
    }

    // Jika sudah URL lengkap, gunakan langsung
    if (_currentUser!.profilePhoto!.startsWith('http')) {
      print('✅ URL foto sudah lengkap: ${_currentUser!.profilePhoto}');
      return _currentUser!.profilePhoto;
    }

    // Jika path relatif, gunakan route images yang baru
    print(
      '🛠️ Membangun URL lengkap untuk foto: ${_currentUser!.profilePhoto}',
    );

    // Bersihkan path
    String cleanPath = _currentUser!.profilePhoto!;
    if (cleanPath.startsWith('/')) cleanPath = cleanPath.substring(1);
    if (cleanPath.startsWith('storage/')) cleanPath = cleanPath.substring(8);

    // Coba beberapa URL yang mungkin
    final possibleUrls = [
      '$apiUrl/images/$cleanPath',
      '$apiUrl/storage/$cleanPath',
      '$baseUrl/storage/$cleanPath',
    ];

    for (final url in possibleUrls) {
      print('🛠️ Mencoba URL: $url');
    }

    return possibleUrls.first;
  }

  // Method untuk update user data secara manual (jika diperlukan)
  void updateUserData(UserModel newUserData) {
    _currentUser = newUserData;
    notifyListeners();
  }

  // Di dalam auth_provider.dart - tambahkan getter ini
  int? get userId => _currentUser?.id;

  // Global key untuk navigator (tambahkan di bagian atas file)
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}
