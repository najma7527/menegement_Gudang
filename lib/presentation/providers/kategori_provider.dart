import 'package:flutter/material.dart';
import '../../data/repositories/kategori_repository.dart';
import '../../data/models/kategori_model.dart';

class KatagoriProvider with ChangeNotifier {
  final KatagoriRepository _katagoriRepository = KatagoriRepository();

  List<KatagoriModel> _katagoriList = [];
  List<KatagoriModel> _filteredKatagoriList = [];
  bool _isLoading = false;
  String? _error;
  int? _currentUserId;

  List<KatagoriModel> get katagoriList => _katagoriList;
  List<KatagoriModel> get filteredKatagoriList => _filteredKatagoriList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // 🔹 RESET METHOD
  void reset() {
    _katagoriList = [];
    _filteredKatagoriList = [];
    _isLoading = false;
    _error = null;
    _currentUserId = null;
    notifyListeners();
    print('🔄 KatagoriProvider di-reset');
  }

  // Set user ID saat provider diinisialisasi
  void setUserId(int? userId) {
    _currentUserId = userId;
    print('👤 User ID diset di KatagoriProvider: $userId');
  }

  Future<void> loadKatagori() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (_currentUserId != null) {
        // Load kategori hanya untuk user ini
        _katagoriList = await _katagoriRepository.getKatagoriByUserId(
          _currentUserId!,
        );
        print(
          '📂 Loaded ${_katagoriList.length} kategori untuk user $_currentUserId',
        );
      } else {
        // Fallback jika user ID belum diset
        _katagoriList = await _katagoriRepository.getKatagori();
        print('📂 Loaded ${_katagoriList.length} kategori (tanpa user filter)');
      }
      _filteredKatagoriList = _katagoriList;
      _error = null;
    } catch (e) {
      _error = e.toString();
      _katagoriList = [];
      _filteredKatagoriList = [];
      print('❌ Error load kategori: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addKatagori(KatagoriModel katagori) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _katagoriRepository.addKatagori(katagori);
      await loadKatagori(); // Reload untuk mendapatkan data terbaru
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateKatagori(int id, KatagoriModel katagori) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _katagoriRepository.updateKatagori(id, katagori);
      await loadKatagori(); // Reload untuk mendapatkan data terbaru
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteKatagori(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _katagoriRepository.deleteKatagori(id);
      await loadKatagori(); // Reload untuk mendapatkan data terbaru
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

  void filterKatagori(String value) {
    if (value.isEmpty) {
      _filteredKatagoriList = _katagoriList;
    } else {
      _filteredKatagoriList = _katagoriList
          .where(
            (katagori) =>
                katagori.nama.toLowerCase().contains(value.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }
}
