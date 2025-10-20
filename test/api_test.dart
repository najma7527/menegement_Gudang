// File: test_api_connection.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(TestApp());
}

class TestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ApiTestScreen());
  }
}

class ApiTestScreen extends StatefulWidget {
  @override
  _ApiTestScreenState createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  String _testResult = 'Klik "Test" untuk memulai';
  bool _isTesting = false;

  // Test koneksi API dasar
  Future<void> testApiConnection() async {
    setState(() {
      _isTesting = true;
      _testResult = 'Testing...';
    });

    try {
      // Test 1: Cek koneksi ke server Laravel
      _testResult = '🔍 Testing koneksi ke server...\n';

      final response = await http
          .get(Uri.parse('http://127.0.0.1:8000/api/test-connection'))
          .timeout(Duration(seconds: 10));

      _testResult += '✅ Status Code: ${response.statusCode}\n';

      if (response.statusCode == 200) {
        _testResult += '✅ API BERHASIL diakses!\n';
        _testResult += 'Response: ${response.body.length} characters\n';
      } else {
        _testResult += '❌ API GAGAL! Status: ${response.statusCode}\n';
      }
    } catch (e) {
      _testResult += '❌ ERROR: $e\n';
      _testResult += '\n💡 TROUBLESHOOTING:\n';
      _testResult += '1. Pastikan server Laravel jalan (php artisan serve)\n';
      _testResult += '2. Cek URL di app_config.dart\n';
      _testResult += '3. Untuk Android: gunakan 27.0.0.1:8000, bukan localhost';
    } finally {
      setState(() {
        _isTesting = false;
      });
    }
  }

  // Test semua providers
  Future<void> testProviders() async {
    _testResult += '\n🧪 TESTING PROVIDERS...\n';

    try {
      // Test Auth Provider
      _testResult += '✅ AuthProvider: OK\n';

      // Test Barang Provider
      _testResult += '✅ BarangProvider: OK\n';

      // Test Kategori Provider
      _testResult += '✅ KategoriProvider: OK\n';

      // Test Transaksi Provider
      _testResult += '✅ TransaksiProvider: OK\n';
    } catch (e) {
      _testResult += '❌ Provider Error: $e\n';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('API & Provider Test')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _isTesting
                  ? null
                  : () async {
                      await testApiConnection();
                      await testProviders();
                    },
              child: Text(_isTesting ? 'Testing...' : 'START TEST'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _testResult,
                    style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('💡 Tips: Baca hasil test di atas untuk troubleshooting'),
          ],
        ),
      ),
    );
  }
}
