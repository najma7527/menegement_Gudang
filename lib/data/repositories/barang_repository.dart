import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/barang_model.dart';
import '../../core/constants/app_config.dart';

class BarangRepository {
  Future<List<BarangModel>> getBarang() async {
    try {
      final response = await http
          .get(Uri.parse('${AppConfig.baseUrl}/barang'))
          .timeout(Duration(milliseconds: AppConfig.connectTimeout));

      print('GET BARANG STATUS: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<BarangModel> barangList = data
            .map((json) => BarangModel.fromJson(json))
            .toList();

        // FIXED: Hapus duplikat berdasarkan ID
        final Map<int, BarangModel> uniqueBarangMap = {};
        for (final barang in barangList) {
          if (barang.id != null) {
            uniqueBarangMap[barang.id!] = barang;
          }
        }

        final uniqueBarangList = uniqueBarangMap.values.toList();
        print('Loaded ${uniqueBarangList.length} unique barang items');

        return uniqueBarangList;
      } else {
        throw Exception('Gagal memuat data barang: ${response.statusCode}');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Koneksi gagal. Periksa koneksi internet dan server.');
      }
      rethrow;
    }
  }

  // TAMBAH: Method untuk get barang by user ID
  Future<List<BarangModel>> getBarangByUserId(int userId) async {
    try {
      final response = await http
          .get(Uri.parse('${AppConfig.baseUrl}/barang?user_id=$userId'))
          .timeout(Duration(milliseconds: AppConfig.connectTimeout));

      print('GET BARANG BY USER STATUS: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<BarangModel> barangList = data
            .map((json) => BarangModel.fromJson(json))
            .toList();

        // Hapus duplikat berdasarkan ID
        final Map<int, BarangModel> uniqueBarangMap = {};
        for (final barang in barangList) {
          if (barang.id != null) {
            uniqueBarangMap[barang.id!] = barang;
          }
        }

        final uniqueBarangList = uniqueBarangMap.values.toList();
        print(
          'Loaded ${uniqueBarangList.length} unique barang items for user $userId',
        );

        return uniqueBarangList;
      } else {
        throw Exception('Gagal memuat data barang: ${response.statusCode}');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Koneksi gagal. Periksa koneksi internet dan server.');
      }
      rethrow;
    }
  }

  Future<BarangModel> getBarangById(int id) async {
    try {
      final response = await http
          .get(Uri.parse('${AppConfig.baseUrl}/barang/$id'))
          .timeout(Duration(milliseconds: AppConfig.connectTimeout));

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        return BarangModel.fromJson(data);
      } else {
        throw Exception('Gagal memuat detail barang: ${response.statusCode}');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Koneksi gagal. Periksa koneksi internet dan server.');
      }
      rethrow;
    }
  }

  Future<BarangModel> addBarang(BarangModel barang) async {
    try {
      final response = await http
          .post(
            Uri.parse('${AppConfig.baseUrl}/barang'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(barang.toJson()),
          )
          .timeout(Duration(milliseconds: AppConfig.connectTimeout));

      print('ADD BARANG STATUS: ${response.statusCode}');
      print('ADD BARANG BODY: ${response.body}');

      if (response.statusCode == 201) {
        final dynamic data = json.decode(response.body);
        return BarangModel.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Gagal menambah barang');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Koneksi gagal. Periksa koneksi internet dan server.');
      }
      rethrow;
    }
  }

  Future<BarangModel> updateBarang(int id, BarangModel barang) async {
    try {
      final response = await http
          .put(
            Uri.parse('${AppConfig.baseUrl}/barang/$id'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(barang.toJson()),
          )
          .timeout(Duration(milliseconds: AppConfig.connectTimeout));

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        return BarangModel.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Gagal mengupdate barang');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Koneksi gagal. Periksa koneksi internet dan server.');
      }
      rethrow;
    }
  }

  // FIXED: Method untuk update stok saja
  Future<BarangModel> updateStokBarang(int id, int stokBaru) async {
    try {
      final response = await http
          .patch(
            Uri.parse('${AppConfig.baseUrl}/barang/$id/stok'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'stok': stokBaru}),
          )
          .timeout(Duration(milliseconds: AppConfig.connectTimeout));

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        return BarangModel.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Gagal update stok barang');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Koneksi gagal. Periksa koneksi internet dan server.');
      }
      rethrow;
    }
  }

  Future<void> deleteBarang(int id) async {
    try {
      final response = await http
          .delete(Uri.parse('${AppConfig.baseUrl}/barang/$id'))
          .timeout(Duration(milliseconds: AppConfig.connectTimeout));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Gagal menghapus barang: ${response.statusCode}');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Koneksi gagal. Periksa koneksi internet dan server.');
      }
      rethrow;
    }
  }
}
