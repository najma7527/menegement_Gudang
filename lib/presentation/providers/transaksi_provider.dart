import 'package:flutter/material.dart';
import '../../data/repositories/transaksi_repository.dart';
import '../../data/models/transaksi_model.dart';
import 'auth_provider.dart';

class TransaksiProvider with ChangeNotifier {
  List<TransaksiModel> _transaksiList = [];
  bool _isLoading = false;
  String? _error;
  int? _currentUserId;
  final AuthProvider _authProvider;

  TransaksiProvider(this._authProvider);

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
    if (_currentUserId == null) {
      print('❌ User ID belum diset, tidak dapat load transaksi');
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = _authProvider.token;
      if (token == null) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final repository = TransaksiRepository(token); 
      _transaksiList = await repository.getTransaksiByUserId(_currentUserId!);
      
      print('💰 Loaded ${_transaksiList.length} transaksi untuk user $_currentUserId');
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
      final token = _authProvider.token;
      if (token == null) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      print('📤 DATA TRANSAKSI KIRIM: ${transaksi.toJson()}');

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
      final repository = TransaksiRepository(token); // 🔥 KIRIM TOKEN
      final newTransaksi = await repository.addTransaksi(transaksi);
      _transaksiList.add(newTransaksi);
      _error = null;
      
      print('✅ Transaksi berhasil disimpan');
      return true;
    } catch (e) {
      _error = e.toString();
      print('❌ Error add transaksi: $e');
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
      final token = _authProvider.token;
      if (token == null) {
        throw Exception('Token tidak tersedia');
      }

      final repository = TransaksiRepository(token); // 🔥 KIRIM TOKEN
      final updatedTransaksi = await repository.updateTransaksi(id, transaksi);
      final index = _transaksiList.indexWhere((t) => t.id == id);
      if (index != -1) {
        _transaksiList[index] = updatedTransaksi;
      }
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      print('❌ Error update transaksi: $e');
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
      final token = _authProvider.token;
      if (token == null) {
        throw Exception('Token tidak tersedia');
      }

      final repository = TransaksiRepository(token); // 🔥 KIRIM TOKEN
      await repository.deleteTransaksi(id);
      _transaksiList.removeWhere((t) => t.id == id);
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      print('❌ Error delete transaksi: $e');
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