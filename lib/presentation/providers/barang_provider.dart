import 'package:flutter/material.dart';
import 'package:gstok/services/notification_service.dart';
import '../../data/repositories/barang_repository.dart';
import '../../data/models/barang_model.dart';

class BarangProvider with ChangeNotifier {
  final BarangRepository _barangRepository = BarangRepository();

  List<BarangModel> _barangList = [];
  bool _isLoading = false;
  String? _error;

  List<BarangModel> get barangList => _barangList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadBarang() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _barangList = await _barangRepository.getBarang();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addBarang(BarangModel barang) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _barangRepository.addBarang(barang);
      await loadBarang();
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
      await loadBarang();
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
      await loadBarang();
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
}
