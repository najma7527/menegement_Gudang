import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/kategori_model.dart';
import '../../core/constants/app_config.dart';

class KatagoriRepository {
  final String? token;

  KatagoriRepository(this.token);

  Future<List<KatagoriModel>> getKatagori() async {
    try {
      final response = await http
          .get(
            Uri.parse('${AppConfig.baseUrl}/katagori'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(Duration(milliseconds: AppConfig.connectTimeout));

      print('GET KATEGORI STATUS: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => KatagoriModel.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - Silakan login kembali');
      } else {
        throw Exception('Gagal memuat data kategori: ${response.statusCode}');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Koneksi gagal. Periksa koneksi internet dan server.');
      }
      rethrow;
    }
  }

  Future<List<KatagoriModel>> getKategoriByUserId(int userId) async {
    try {
      print('🚀 GET Kategori for user: $userId');
      print('🔐 Token: $token');

      if (token == null || token!.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http
          .get(
            Uri.parse('${AppConfig.baseUrl}/katagori/user/$userId'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(Duration(seconds: 10));

      print('📦 Response status: ${response.statusCode}');
      print('📦 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // 🔥 PERBAIKAN: Handle berbagai format response
        if (responseData.containsKey('data')) {
          final List<dynamic> data = responseData['data'];
          final result = data
              .map((json) => KatagoriModel.fromJson(json))
              .toList();
          print('✅ Successfully loaded ${result.length} kategori for user $userId');
          return result;
        } 
        // Jika response langsung array (tanpa wrapper)
        else if (responseData is List) {
          final result = (responseData as List)
              .map((json) => KatagoriModel.fromJson(json))
              .toList();
          print('✅ Successfully loaded ${result.length} kategori for user $userId');
          return result;
        }
        // Jika menggunakan format success/status
        else if (responseData['success'] == true || responseData['status'] == 'success') {
          final List<dynamic> data = responseData['data'] ?? [];
          final result = data
              .map((json) => KatagoriModel.fromJson(json))
              .toList();
          print('✅ Successfully loaded ${result.length} kategori for user $userId');
          return result;
        } else {
          throw Exception('Format response tidak dikenali: ${responseData.keys}');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - Token tidak valid');
      } else if (response.statusCode == 404) {
        throw Exception('Endpoint kategori tidak ditemukan');
      } else {
        throw Exception('Failed to load kategori: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Repository error: $e');
      rethrow;
    }
  }

  Future<KatagoriModel> getKatagoriById(int id) async {
    try {
      final response = await http
          .get(
            Uri.parse('${AppConfig.baseUrl}/katagori/$id'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token', // 🔥 TAMBAHKAN AUTHORIZATION
            },
          )
          .timeout(Duration(milliseconds: AppConfig.connectTimeout));

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        return KatagoriModel.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - Silakan login kembali');
      } else {
        throw Exception('Gagal memuat detail kategori: ${response.statusCode}');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Koneksi gagal. Periksa koneksi internet dan server.');
      }
      rethrow;
    }
  }

  Future<KatagoriModel> addKatagori(KatagoriModel katagori) async {
    try {
      print("DATA KIRIM: ${json.encode(katagori.toJson())}");
      final response = await http
          .post(
            Uri.parse('${AppConfig.baseUrl}/katagori'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token', // 🔥 TAMBAHKAN AUTHORIZATION
            },
            body: json.encode(katagori.toJson()),
          )
          .timeout(Duration(milliseconds: AppConfig.connectTimeout));

      print('ADD KATEGORI STATUS: ${response.statusCode}');

      if (response.statusCode == 201) {
        final dynamic data = json.decode(response.body);
        return KatagoriModel.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Gagal menambah kategori');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Koneksi gagal. Periksa koneksi internet dan server.');
      }
      rethrow;
    }
  }

  Future<KatagoriModel> updateKatagori(int id, KatagoriModel katagori) async {
    try {
      print("DATA KIRIM: ${json.encode(katagori.toJson())}");
      final response = await http
          .put(
            Uri.parse('${AppConfig.baseUrl}/katagori/$id'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token', // 🔥 TAMBAHKAN AUTHORIZATION
            },
            body: json.encode(katagori.toJson()),
          )
          .timeout(Duration(milliseconds: AppConfig.connectTimeout));

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        return KatagoriModel.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Gagal mengupdate kategori');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Koneksi gagal. Periksa koneksi internet dan server.');
      }
      rethrow;
    }
  }

  Future<void> deleteKatagori(int id) async {
    try {
      final response = await http
          .delete(
            Uri.parse('${AppConfig.baseUrl}/katagori/$id'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token', // 🔥 TAMBAHKAN AUTHORIZATION
            },
          )
          .timeout(Duration(milliseconds: AppConfig.connectTimeout));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Gagal menghapus kategori: ${response.statusCode}');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Koneksi gagal. Periksa koneksi internet dan server.');
      }
      rethrow;
    }
  }
}
