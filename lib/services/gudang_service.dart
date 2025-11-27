import 'package:shared_preferences/shared_preferences.dart';

class GudangService {
  static const String _namaGudangKey = 'nama_gudang';
  static const String _alamatGudangKey = 'alamat_gudang';

  static Future<void> setNamaGudang(String nama) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_namaGudangKey, nama);
  }

  static Future<void> setAlamatGudang(String alamat) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_alamatGudangKey, alamat);
  }

  static Future<void> setGudang(String nama, String alamat) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_namaGudangKey, nama);
    await prefs.setString(_alamatGudangKey, alamat);
  }

  static Future<String?> getNamaGudang() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_namaGudangKey);
  }

  static Future<String?> getAlamatGudang() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_alamatGudangKey);
  }

  static Future<Map<String, String?>> getGudang() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'nama': prefs.getString(_namaGudangKey),
      'alamat': prefs.getString(_alamatGudangKey),
    };
  }

  static Future<bool> hasGudangData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_namaGudangKey) &&
        prefs.containsKey(_alamatGudangKey);
  }

  static Future<void> clearGudang() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_namaGudangKey);
    await prefs.remove(_alamatGudangKey);
  }
}
