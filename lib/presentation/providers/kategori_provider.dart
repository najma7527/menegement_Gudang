import 'package:flutter/material.dart';
import '../../data/repositories/kategori_repository.dart';
import '../../data/models/kategori_model.dart';
import 'auth_provider.dart';

class KatagoriProvider with ChangeNotifier {
  List<KatagoriModel> _katagoriList = [];
  List<KatagoriModel> _filteredKatagoriList = [];
  bool _isLoading = false;
  String? _error;
  int? _currentUserId;
  final AuthProvider _authProvider;

  KatagoriProvider(this._authProvider);

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
    if (_currentUserId == null) {
      print('❌ User ID belum diset, tidak dapat load kategori');
      return;
    }

    _isLoading = true;
    _error = null;

    // 🔥 PERBAIKAN: Tunda notifyListeners sampai setelah build selesai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      final token = _authProvider.token;
      if (token == null) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final repository = KatagoriRepository(token);
      _katagoriList = await repository.getKategoriByUserId(_currentUserId!);
      _filteredKatagoriList = _katagoriList;

      print(
        '📂 Loaded ${_katagoriList.length} kategori untuk user $_currentUserId',
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
      _katagoriList = [];
      _filteredKatagoriList = [];
      print('❌ Error load kategori: $e');
    } finally {
      _isLoading = false;

      // 🔥 PERBAIKAN: Tunda notifyListeners sampai setelah build selesai
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  Future<bool> addKatagori(KatagoriModel katagori) async {
    _isLoading = true;

    // 🔥 PERBAIKAN: Tunda notifyListeners sampai setelah build selesai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      final token = _authProvider.token;
      if (token == null) {
        throw Exception('Token tidak tersedia');
      }

      final repository = KatagoriRepository(token);
      await repository.addKatagori(katagori);
      await loadKatagori(); // Reload untuk mendapatkan data terbaru
      return true;
    } catch (e) {
      _error = e.toString();
      print('❌ Error add kategori: $e');
      return false;
    } finally {
      _isLoading = false;

      // 🔥 PERBAIKAN: Tunda notifyListeners sampai setelah build selesai
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  Future<bool> updateKatagori(int id, KatagoriModel katagori) async {
    _isLoading = true;

    // 🔥 PERBAIKAN: Tunda notifyListeners sampai setelah build selesai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      final token = _authProvider.token;
      if (token == null) {
        throw Exception('Token tidak tersedia');
      }

      final repository = KatagoriRepository(token);
      await repository.updateKatagori(id, katagori);
      await loadKatagori(); // Reload untuk mendapatkan data terbaru
      return true;
    } catch (e) {
      _error = e.toString();
      print('❌ Error update kategori: $e');
      return false;
    } finally {
      _isLoading = false;

      // 🔥 PERBAIKAN: Tunda notifyListeners sampai setelah build selesai
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  Future<bool> deleteKatagori(int id) async {
    _isLoading = true;

    // 🔥 PERBAIKAN: Tunda notifyListeners sampai setelah build selesai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      final token = _authProvider.token;
      if (token == null) {
        throw Exception('Token tidak tersedia');
      }

      final repository = KatagoriRepository(token);
      await repository.deleteKatagori(id);
      await loadKatagori(); // Reload untuk mendapatkan data terbaru
      return true;
    } catch (e) {
      _error = e.toString();
      print('❌ Error delete kategori: $e');
      return false;
    } finally {
      _isLoading = false;

      // 🔥 PERBAIKAN: Tunda notifyListeners sampai setelah build selesai
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void clearError() {
    _error = null;

    // 🔥 PERBAIKAN: Tunda notifyListeners sampai setelah build selesai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
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

    // 🔥 PERBAIKAN: Tunda notifyListeners sampai setelah build selesai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Method untuk mendapatkan kategori by ID
  KatagoriModel? getKatagoriById(int id) {
    try {
      return _katagoriList.firstWhere((k) => k.id == id);
    } catch (e) {
      return null;
    }
  }
}
