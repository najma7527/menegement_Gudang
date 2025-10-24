import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaksi_model.dart';
import '../../core/constants/app_config.dart';

class TransaksiRepository {
  final String? token;

  TransaksiRepository(this.token);

  Future<List<TransaksiModel>> getTransaksiByUserId(int userId) async {
    try {
      print('🚀 GET Transaksi for user: $userId');
      print('🔐 Token: $token');

      if (token == null || token!.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http
          .get(
            Uri.parse('${AppConfig.baseUrl}/transaksi/user/$userId'),
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
              .map((json) => TransaksiModel.fromJson(json))
              .toList();
          print(
            '✅ Successfully loaded ${result.length} transaksi for user $userId',
          );
          return result;
        }
        // Jika response langsung array (tanpa wrapper)
        else if (responseData is List) {
          final result = (responseData as List)
              .map((json) => TransaksiModel.fromJson(json))
              .toList();
          print(
            '✅ Successfully loaded ${result.length} transaksi for user $userId',
          );
          return result;
        }
        // Jika menggunakan format success/status
        else if (responseData['success'] == true ||
            responseData['status'] == 'success') {
          final List<dynamic> data = responseData['data'] ?? [];
          final result = data
              .map((json) => TransaksiModel.fromJson(json))
              .toList();
          print(
            '✅ Successfully loaded ${result.length} transaksi for user $userId',
          );
          return result;
        } else {
          throw Exception(
            'Format response tidak dikenali: ${responseData.keys}',
          );
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - Token tidak valid');
      } else if (response.statusCode == 404) {
        throw Exception('Endpoint transaksi tidak ditemukan');
      } else {
        throw Exception('Failed to load transaksi: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Repository error: $e');
      rethrow;
    }
  }

  Future<TransaksiModel> getTransaksiById(int id) async {
    try {
      final response = await http
          .get(
            Uri.parse('${AppConfig.baseUrl}/transaksi/$id'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token', // 🔥 TAMBAHKAN AUTHORIZATION
            },
          )
          .timeout(Duration(milliseconds: AppConfig.connectTimeout));

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        return TransaksiModel.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - Silakan login kembali');
      } else {
        throw Exception(
          'Gagal memuat detail transaksi: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Koneksi gagal. Periksa koneksi internet dan server.');
      }
      rethrow;
    }
  }

  Future<TransaksiModel> addTransaksi(TransaksiModel transaksi) async {
    try {
      print('📤 DATA TRANSAKSI KIRIM: ${transaksi.toJson()}');

      final response = await http
          .post(
            Uri.parse('${AppConfig.baseUrl}/transaksi'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token', // 🔥 TAMBAHKAN AUTHORIZATION
            },
            body: json.encode(transaksi.toJson()),
          )
          .timeout(Duration(milliseconds: AppConfig.connectTimeout));

      print('ADD TRANSAKSI STATUS: ${response.statusCode}');
      print('ADD TRANSAKSI BODY: ${response.body}');

      if (response.statusCode == 201) {
        final dynamic data = json.decode(response.body);
        return TransaksiModel.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Gagal menambah transaksi');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Koneksi gagal. Periksa koneksi internet dan server.');
      }
      rethrow;
    }
  }

  Future<TransaksiModel> updateTransaksi(
    int id,
    TransaksiModel transaksi,
  ) async {
    try {
      final response = await http
          .put(
            Uri.parse('${AppConfig.baseUrl}/transaksi/$id'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token', // 🔥 TAMBAHKAN AUTHORIZATION
            },
            body: json.encode(transaksi.toJson()),
          )
          .timeout(Duration(milliseconds: AppConfig.connectTimeout));

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        return TransaksiModel.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Gagal mengupdate transaksi');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Koneksi gagal. Periksa koneksi internet dan server.');
      }
      rethrow;
    }
  }

  Future<void> deleteTransaksi(int id) async {
    try {
      final response = await http
          .delete(
            Uri.parse('${AppConfig.baseUrl}/transaksi/$id'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token', // 🔥 TAMBAHKAN AUTHORIZATION
            },
          )
          .timeout(Duration(milliseconds: AppConfig.connectTimeout));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Gagal menghapus transaksi: ${response.statusCode}');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Koneksi gagal. Periksa koneksi internet dan server.');
      }
      rethrow;
    }
  }

  // Method untuk statistik
  Future<Map<String, dynamic>> getStatistik() async {
    try {
      final response = await http
          .get(
            Uri.parse('${AppConfig.baseUrl}/transaksi/statistik'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token', // 🔥 TAMBAHKAN AUTHORIZATION
            },
          )
          .timeout(Duration(milliseconds: AppConfig.connectTimeout));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Gagal memuat statistik: ${response.statusCode}');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Koneksi gagal. Periksa koneksi internet dan server.');
      }
      rethrow;
    }
  }
}
