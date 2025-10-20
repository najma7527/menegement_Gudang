// lib/services/api_service.dart
import 'package:dio/dio.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      },
    ),
  );

  // Test GET connection
  static Future<void> testGetConnection() async {
    try {
      print('=== TEST GET CONNECTION ===');
      final response = await _dio.get('/test-connection');
      
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');
      print('✅ GET request BERHASIL: ${response.data['message']}');
    } catch (e) {
      print('❌ GET request GAGAL: $e');
    }
  }

  // Test POST connection dengan handling CSRF
  static Future<void> testPostConnection() async {
    try {
      print('\n=== TEST POST CONNECTION ===');
      
      final response = await _dio.post(
        '/test-post',
        data: {
          'test_data': 'Hello from Flutter',
          'timestamp': DateTime.now().toString(),
          'flutter_app': true,
        },
      );
      
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');
      print('✅ POST request BERHASIL: ${response.data['message']}');
    } on DioException catch (e) {
      print('❌ POST request GAGAL:');
      print('Error Type: ${e.type}');
      print('Error Message: ${e.message}');
      print('Status Code: ${e.response?.statusCode}');
      
      if (e.response?.statusCode == 419) {
        print('💡 Solution: Tambahkan CSRF exception di Laravel');
      }
    } catch (e) {
      print('❌ ERROR: $e');
    }
  }

  // Test dengan endpoint barang yang sudah ada
  static Future<void> testBarangEndpoint() async {
    try {
      print('\n=== TEST BARANG ENDPOINT ===');
      
      // GET barang
      final getResponse = await _dio.get('/barang');
      print('GET Barang - Status: ${getResponse.statusCode}');
      print('Data: ${getResponse.data}');
      
      // POST barang (jika ada data)
      final postResponse = await _dio.post(
        '/barang',
        data: {
          'nama': 'Test dari Flutter',
          'harga': 10000,
          'stok': 5,
          'katagori_id': 1,
        },
      );
      print('POST Barang - Status: ${postResponse.statusCode}');
      
    } on DioException catch (e) {
      print('Barang Endpoint Error: ${e.response?.statusCode}');
    }
  }
}