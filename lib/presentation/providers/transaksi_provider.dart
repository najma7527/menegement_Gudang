import 'package:flutter/material.dart';
import '../../data/repositories/transaksi_repository.dart';
import '../../data/models/transaksi_model.dart';

class TransaksiProvider with ChangeNotifier {
  final TransaksiRepository _transaksiRepository = TransaksiRepository();

  List<TransaksiModel> _transaksiList = [];
  bool _isLoading = false;
  String? _error;

  List<TransaksiModel> get transaksiList => _transaksiList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadTransaksi() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _transaksiList = await _transaksiRepository.getTransaksi();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _transaksiList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // UBAH: Tambahkan parameter BarangProvider untuk update stok
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
