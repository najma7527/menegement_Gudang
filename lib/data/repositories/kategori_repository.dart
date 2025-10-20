import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/kategori_model.dart';
import '../../core/constants/app_config.dart';

class KatagoriRepository {
  Future<List<KatagoriModel>> getKatagori() async {
    try {
      final response = await http
          .get(Uri.parse('${AppConfig.baseUrl}/katagori'))
          .timeout(Duration(milliseconds: AppConfig.connectTimeout));

      print('GET KATEGORI STATUS: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => KatagoriModel.fromJson(json)).toList();
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

  Future<KatagoriModel> getKatagoriById(int id) async {
    try {
      final response = await http
          .get(Uri.parse('${AppConfig.baseUrl}/katagori/$id'))
          .timeout(Duration(milliseconds: AppConfig.connectTimeout));

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        return KatagoriModel.fromJson(data);
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
            headers: {'Content-Type': 'application/json'},
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
            headers: {'Content-Type': 'application/json'},
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
          .delete(Uri.parse('${AppConfig.baseUrl}/katagori/$id'))
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
