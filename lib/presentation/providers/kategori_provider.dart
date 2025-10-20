import 'package:flutter/material.dart';
import '../../data/repositories/kategori_repository.dart';
import '../../data/models/kategori_model.dart';

class KatagoriProvider with ChangeNotifier {
  final KatagoriRepository _katagoriRepository = KatagoriRepository();

  List<KatagoriModel> _katagoriList = [];
  List<KatagoriModel> _filteredKatagoriList = [];
  bool _isLoading = false;
  String? _error;

  List<KatagoriModel> get katagoriList => _katagoriList;
  List<KatagoriModel> get filteredKatagoriList => _filteredKatagoriList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadKatagori() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _katagoriList = await _katagoriRepository.getKatagori();
      _filteredKatagoriList = _katagoriList;
      _error = null;
    } catch (e) {
      _error = e.toString();
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
      await loadKatagori();
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
      await loadKatagori();
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
      await loadKatagori();
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
