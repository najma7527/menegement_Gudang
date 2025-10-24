import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/barang_provider.dart';
import '../providers/kategori_provider.dart';
import '../providers/transaksi_provider.dart';
import '../providers/auth_provider.dart';

class ProviderManager {
  static void resetAllProviders(BuildContext context) {
    // Reset semua provider data
    Provider.of<BarangProvider>(context, listen: false).reset();
    Provider.of<KatagoriProvider>(context, listen: false).reset();
    Provider.of<TransaksiProvider>(context, listen: false).reset();

    print('✅ Semua provider telah di-reset');
  }

  static void setUserIdForAllProviders(BuildContext context, int userId) {
    Provider.of<BarangProvider>(context, listen: false).setUserId(userId);
    Provider.of<KatagoriProvider>(context, listen: false).setUserId(userId);
    Provider.of<TransaksiProvider>(context, listen: false).setUserId(userId);

    print('✅ User ID $userId diset ke semua provider');
  }

  static void loadAllData(BuildContext context) async {
    final barangProvider = Provider.of<BarangProvider>(context, listen: false);
    final kategoriProvider = Provider.of<KatagoriProvider>(
      context,
      listen: false,
    );
    final transaksiProvider = Provider.of<TransaksiProvider>(
      context,
      listen: false,
    );

    await Future.wait([
      barangProvider.loadBarangByUser(),
      kategoriProvider.loadKatagori(),
      transaksiProvider.loadTransaksi(),
    ]);

    print('✅ Semua data loaded untuk user');
  }
}
