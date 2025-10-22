import 'package:flutter/material.dart';
import '../../data/repositories/transaksi_repository.dart';
import '../../data/models/transaksi_model.dart';

class TransaksiProvider with ChangeNotifier {
  final TransaksiRepository _transaksiRepository = TransaksiRepository();

  List<TransaksiModel> _transaksiList = [];
  bool _isLoading = false;
  String? _error;
  int? _currentUserId;

  List<TransaksiModel> get transaksiList => _transaksiList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // 🔹 RESET METHOD
  void reset() {
    _transaksiList = [];
    _isLoading = false;
    _error = null;
    _currentUserId = null;
    notifyListeners();
    print('🔄 TransaksiProvider di-reset');
  }

  // Set user ID saat provider diinisialisasi
  void setUserId(int? userId) {
    _currentUserId = userId;
    print('👤 User ID diset di TransaksiProvider: $userId');
  }

  Future<void> loadTransaksi() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (_currentUserId != null) {
        // Load transaksi hanya untuk user ini
        _transaksiList = await _transaksiRepository.getTransaksiByUserId(
          _currentUserId!,
        );
        print(
          '💰 Loaded ${_transaksiList.length} transaksi untuk user $_currentUserId',
        );
      } else {
        // Fallback jika user ID belum diset
        _transaksiList = await _transaksiRepository.getTransaksi();
        print(
          '💰 Loaded ${_transaksiList.length} transaksi (tanpa user filter)',
        );
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
      _transaksiList = [];
      print('❌ Error load transaksi: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addTransaksi(
    TransaksiModel transaksi, {
    required Function updateStokCallback,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Update stok barang terlebih dahulu
      final stokSuccess = await updateStokCallback(
        transaksi.barangId,
        transaksi.jumlah,
        transaksi.tipeTransaksi,
      );

      if (!stokSuccess) {
        throw Exception('Gagal update stok barang');
      }

      // Jika update stok berhasil, simpan transaksi
      final newTransaksi = await _transaksiRepository.addTransaksi(transaksi);
      _transaksiList.add(newTransaksi);
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateTransaksi(int id, TransaksiModel transaksi) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedTransaksi = await _transaksiRepository.updateTransaksi(
        id,
        transaksi,
      );
      final index = _transaksiList.indexWhere((t) => t.id == id);
      if (index != -1) {
        _transaksiList[index] = updatedTransaksi;
      }
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteTransaksi(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _transaksiRepository.deleteTransaksi(id);
      _transaksiList.removeWhere((t) => t.id == id);
      _error = null;
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
}
