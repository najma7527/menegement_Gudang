import 'package:flutter/material.dart';
import 'package:gstok/services/notification_service.dart';
import '../../data/repositories/barang_repository.dart';
import '../../data/models/barang_model.dart';

class BarangProvider with ChangeNotifier {
  final BarangRepository _barangRepository = BarangRepository();

  List<BarangModel> _barangList = [];
  bool _isLoading = false;
  String? _error;
  int? _currentUserId;

  List<BarangModel> get barangList => _barangList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // 🔹 RESET METHOD
  void reset() {
    _barangList = [];
    _isLoading = false;
    _error = null;
    _currentUserId = null;
    notifyListeners();
    print('🔄 BarangProvider di-reset');
  }

  // Set user ID saat provider diinisialisasi
  void setUserId(int? userId) {
    _currentUserId = userId;
    print('👤 User ID diset di BarangProvider: $userId');
  }

  Future<void> loadBarang() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (_currentUserId != null) {
        // Load barang hanya untuk user ini
        _barangList = await _barangRepository.getBarangByUserId(
          _currentUserId!,
        );
        print(
          '📦 Loaded ${_barangList.length} barang untuk user $_currentUserId',
        );
      } else {
        // Fallback jika user ID belum diset
        _barangList = await _barangRepository.getBarang();
        print('📦 Loaded ${_barangList.length} barang (tanpa user filter)');
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
      _barangList = [];
      print('❌ Error load barang: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addBarang(BarangModel barang) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Pastikan barang memiliki user ID yang benar
      final barangWithUserId = barang.copyWith(userId: _currentUserId);
      await _barangRepository.addBarang(barangWithUserId);
      await loadBarang(); // Reload untuk mendapatkan data terbaru
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateBarang(int id, BarangModel barang) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _barangRepository.updateBarang(id, barang);
      await loadBarang(); // Reload untuk mendapatkan data terbaru
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateStokBarang(int barangId, int jumlah, String tipe) async {
    _isLoading = true;
    notifyListeners();

    try {
      final barang = getBarangById(barangId);
      if (barang == null) {
        throw Exception("Barang tidak ditemukan");
      }

      // Hitung stok baru
      int stokBaru = barang.stok;
      if (tipe == 'masuk') {
        stokBaru += jumlah;
      } else if (tipe == 'keluar') {
        stokBaru -= jumlah;
      }

      if (stokBaru <= 5) {
        await NotificationService().showLowStockNotification(
          barang.nama,
          stokBaru,
        );
      }

      // Buat model baru dengan stok yang sudah diupdate
      final updatedBarang = barang.copyWith(stok: stokBaru);

      // Simpan ke backend lewat repository
      await _barangRepository.updateBarang(barangId, updatedBarang);

      // Update local state
      final index = _barangList.indexWhere((b) => b.id == barangId);
      if (index != -1) {
        _barangList[index] = updatedBarang;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteBarang(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _barangRepository.deleteBarang(id);
      await loadBarang(); // Reload untuk mendapatkan data terbaru
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  BarangModel? getBarangById(int id) {
    try {
      return barangList.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  List<BarangModel> get criticalStockItems {
    return _barangList.where((barang) => barang.stok <= 5).toList();
  }

  // 🚨 METHOD BARU: Cek apakah ada stok kritis
  bool get hasCriticalStock => criticalStockItems.isNotEmpty;

  // 🚨 METHOD BARU: Hitung jumlah barang stok kritis
  int get criticalStockCount => criticalStockItems.length;

  // 🚨 METHOD BARU: Ambil status stok untuk barang tertentu
  String getStockStatus(BarangModel barang) {
    if (barang.stok <= 0) return 'HABIS';
    if (barang.stok <= 5) return 'MENIPIS';
    return 'AMAN';
  }

  // 🚨 METHOD BARU: Ambil color status untuk barang tertentu
  Color getStockStatusColor(BarangModel barang) {
    if (barang.stok <= 0) return Colors.red;
    if (barang.stok <= 5) return Colors.orange;
    return Colors.green;
  }

  getKategoriById(kategoriId) {}
}
