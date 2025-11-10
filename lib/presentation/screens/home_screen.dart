import 'package:flutter/material.dart';
import 'package:gstok/data/models/barang_model.dart';
import 'package:gstok/presentation/screens/responsive_layout.dart';
import 'package:provider/provider.dart';
import '../providers/barang_provider.dart';
import '../providers/transaksi_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/kategori_provider.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Dashboard',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: ResponsiveLayout.isMobile(context) ? 20 : 24,
        ),
      ),
      backgroundColor: AppColors.primary,
      elevation: 0,
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildBody(BuildContext context) {
    final barangProvider = Provider.of<BarangProvider>(context);
    final transaksiProvider = Provider.of<TransaksiProvider>(context);
    final kategoriProvider = Provider.of<KatagoriProvider>(context);

    final totalBarang = barangProvider.barangList.length;
    final totalKategori = kategoriProvider.katagoriList.length;
    final transaksiMasuk = transaksiProvider.transaksiList
        .where((t) => t.tipeTransaksi == 'masuk')
        .length;
    final transaksiKeluar = transaksiProvider.transaksiList
        .where((t) => t.tipeTransaksi == 'keluar')
        .length;

    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveLayout.getPadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(context, Provider.of<AuthProvider>(context)),
          SizedBox(height: 24),
          if (barangProvider.hasCriticalStock)
            _buildCriticalStockSection(barangProvider, context),
          if (barangProvider.hasCriticalStock) SizedBox(height: 24),
          _buildChartSection(transaksiProvider, context),
          SizedBox(height: 24),

          _buildStatsGrid(
            totalBarang,
            totalKategori,
            transaksiMasuk,
            transaksiKeluar,
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCriticalStockSection(
    BarangProvider barangProvider,
    BuildContext context,
  ) {
    final criticalItems = barangProvider.criticalStockItems;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveLayout.isMobile(context) ? 16 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dengan icon warning
              Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Stok Perlu Perhatian',
                    style: TextStyle(
                      fontSize: ResponsiveLayout.isMobile(context) ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${criticalItems.length}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // List barang stok kritis (maksimal 3 item)
              Column(
                children: criticalItems
                    .take(3)
                    .map(
                      (barang) => _buildCriticalStockItem(
                        barang,
                        barangProvider,
                        context,
                      ),
                    )
                    .toList(),
              ),

              // Tampilkan "Lihat Semua" jika lebih dari 3 item
              if (criticalItems.length > 3)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: GestureDetector(
                    onTap: () {
                      // Bisa navigate ke halaman barang dengan filter stok kritis
                      _showAllCriticalItems(context, barangProvider);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Lihat ${criticalItems.length - 3} item lainnya',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 12,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // 🚨 WIDGET BARU: Item stok kritis
  Widget _buildCriticalStockItem(
    BarangModel barang,
    BarangProvider barangProvider,
    BuildContext context,
  ) {
    final statusColor = barangProvider.getStockStatusColor(barang);
    final statusText = barangProvider.getStockStatus(barang);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Status Indicator
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 12),

          // Item Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  barang.nama,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveLayout.isMobile(context) ? 14 : 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Stock Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: ResponsiveLayout.isMobile(context) ? 10 : 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🚨 METHOD BARU: Dialog untuk lihat semua stok kritis
  void _showAllCriticalItems(
    BuildContext context,
    BarangProvider barangProvider,
  ) {
    final criticalItems = barangProvider.criticalStockItems;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('Semua Stok Kritis'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: criticalItems.length,
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    criticalItems[index].stok <= 0
                        ? Icons.error_outline
                        : Icons.warning_amber,
                    color: barangProvider.getStockStatusColor(
                      criticalItems[index],
                    ),
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          criticalItems[index].nama,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: barangProvider
                          .getStockStatusColor(criticalItems[index])
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${barangProvider.getStockStatus(criticalItems[index])} • ${criticalItems[index].stok}',
                      style: TextStyle(
                        color: barangProvider.getStockStatusColor(
                          criticalItems[index],
                        ),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(
    int totalBarang,
    int totalKategori,
    int transaksiMasuk,
    int transaksiKeluar,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = ResponsiveLayout.isMobile(context);
        final crossAxisCount = isMobile ? 2 : 3;
        final childAspectRatio = isMobile ? 1.2 : 1.4;

        return GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: childAspectRatio,
          children: [
            _buildStatCard(
              'Total Barang',
              totalBarang.toString(),
              Icons.inventory,
              AppColors.primary,
              context,
            ),
            _buildStatCard(
              'Total Kategori',
              totalKategori.toString(),
              Icons.category,
              AppColors.primary,
              context,
            ),
            _buildStatCard(
              'Barang Masuk',
              transaksiMasuk.toString(),
              Icons.arrow_downward,
              AppColors.success,
              context,
            ),
            _buildStatCard(
              'Barang Keluar',
              transaksiKeluar.toString(),
              Icons.arrow_upward,
              AppColors.error,
              context,
            ),
          ],
        );
      },
    );
  }

  Widget _buildWelcomeCard(BuildContext context, dynamic authProvider) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(0.05),
              AppColors.primary.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveLayout.isMobile(context) ? 16 : 20),
          child: Row(
            children: [
              CircleAvatar(
                radius: ResponsiveLayout.isMobile(context) ? 25 : 30,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Icon(
                  Icons.person,
                  color: AppColors.primary,
                  size: ResponsiveLayout.isMobile(context) ? 25 : 30,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, ${authProvider.user?.name ?? 'User'}!',
                      style: TextStyle(
                        fontSize: ResponsiveLayout.isMobile(context) ? 18 : 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Selamat datang di sistem inventory',
                      style: TextStyle(
                        color: AppColors.grey600,
                        fontSize: ResponsiveLayout.isMobile(context) ? 12 : 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartSection(
    TransaksiProvider transaksiProvider,
    BuildContext context,
  ) {
    final transaksiMasuk = transaksiProvider.transaksiList
        .where((t) => t.tipeTransaksi == 'masuk')
        .length;
    final transaksiKeluar = transaksiProvider.transaksiList
        .where((t) => t.tipeTransaksi == 'keluar')
        .length;
    final total = transaksiMasuk + transaksiKeluar;
    final masukPercent = total > 0 ? (transaksiMasuk / total) * 100 : 0;
    final keluarPercent = total > 0 ? (transaksiKeluar / total) * 100 : 0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveLayout.isMobile(context) ? 16 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistik Transaksi',
              style: TextStyle(
                fontSize: ResponsiveLayout.isMobile(context) ? 16 : 18,
                fontWeight: FontWeight.bold,
                color: AppColors.grey800,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Masuk',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                          fontSize: ResponsiveLayout.isMobile(context)
                              ? 12
                              : 14,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '$transaksiMasuk',
                        style: TextStyle(
                          fontSize: ResponsiveLayout.isMobile(context)
                              ? 20
                              : 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${masukPercent.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: AppColors.grey600,
                          fontSize: ResponsiveLayout.isMobile(context)
                              ? 10
                              : 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Keluar',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.error,
                          fontSize: ResponsiveLayout.isMobile(context)
                              ? 12
                              : 14,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '$transaksiKeluar',
                        style: TextStyle(
                          fontSize: ResponsiveLayout.isMobile(context)
                              ? 20
                              : 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.error,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${keluarPercent.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: AppColors.grey600,
                          fontSize: ResponsiveLayout.isMobile(context)
                              ? 10
                              : 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.grey200,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: transaksiMasuk,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        gradient: LinearGradient(
                          colors: [AppColors.success, Colors.green[400]!],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: transaksiKeluar,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        gradient: LinearGradient(
                          colors: [AppColors.error, Colors.red[400]!],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pemasukan',
                  style: TextStyle(
                    color: AppColors.grey600,
                    fontSize: ResponsiveLayout.isMobile(context) ? 10 : 12,
                  ),
                ),
                Text(
                  'Pengeluaran',
                  style: TextStyle(
                    color: AppColors.grey600,
                    fontSize: ResponsiveLayout.isMobile(context) ? 10 : 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    BuildContext context,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 229, 237, 255),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveLayout.isMobile(context) ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(
                      ResponsiveLayout.isMobile(context) ? 8 : 12,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: ResponsiveLayout.isMobile(context) ? 20 : 24,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: ResponsiveLayout.isMobile(context) ? 22 : 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey800,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveLayout.isMobile(context) ? 8 : 12),
              Text(
                title,
                style: TextStyle(
                  color: AppColors.grey600,
                  fontWeight: FontWeight.w600,
                  fontSize: ResponsiveLayout.isMobile(context) ? 12 : 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
