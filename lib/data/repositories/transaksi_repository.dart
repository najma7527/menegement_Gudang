import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaksi_model.dart';
import '../../core/constants/app_config.dart';

class TransaksiRepository {
  Future<List<TransaksiModel>> getTransaksi() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/transaksi')
      ).timeout(Duration(milliseconds: AppConfig.connectTimeout));

      print('GET TRANSAKSI STATUS: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => TransaksiModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data transaksi: ${response.statusCode}');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Koneksi gagal. Periksa koneksi internet dan server.');
      }
      rethrow;
    }
  }

  // TAMBAH: Method untuk get transaksi by user ID
  Future<List<TransaksiModel>> getTransaksiByUserId(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/transaksi?user_id=$userId')
      ).timeout(Duration(milliseconds: AppConfig.connectTimeout));

      print('GET TRANSAKSI BY USER STATUS: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => TransaksiModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data transaksi: ${response.statusCode}');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Koneksi gagal. Periksa koneksi internet dan server.');
      }
      rethrow;
    }
  }

  Future<TransaksiModel> getTransaksiById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/transaksi/$id')
      ).timeout(Duration(milliseconds: AppConfig.connectTimeout));

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        return TransaksiModel.fromJson(data);
      } else {
        throw Exception('Gagal memuat detail transaksi: ${response.statusCode}');
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
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/transaksi'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(transaksi.toJson()),
      ).timeout(Duration(milliseconds: AppConfig.connectTimeout));

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

  Future<TransaksiModel> updateTransaksi(int id, TransaksiModel transaksi) async {
    try {
      final response = await http.put(
        Uri.parse('${AppConfig.baseUrl}/transaksi/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(transaksi.toJson()),
      ).timeout(Duration(milliseconds: AppConfig.connectTimeout));

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
      final response = await http.delete(
        Uri.parse('${AppConfig.baseUrl}/transaksi/$id')
      ).timeout(Duration(milliseconds: AppConfig.connectTimeout));

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
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/transaksi/statistik')
      ).timeout(Duration(milliseconds: AppConfig.connectTimeout));

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